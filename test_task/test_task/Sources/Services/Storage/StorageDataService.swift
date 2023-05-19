import Foundation
import CoreData

// MARK: - Storage data service protocol

protocol StorageDataServiceProtocol: AnyObject {
    func setObjectsLimit(value: Int)
    func cutByLimitIfNeeded()
    
    func fetchAllPrompts() -> [String]
    func saveImageItemModel(model: ImageItemModel, timeStamp: Date, id: UUID)
    func fetchAllSortedImageItemModels() -> [ImageItemModel]
    func removeAllData()
}

// MARK: - Storage data service

final class StorageDataService: StorageDataServiceProtocol {
  
    private var objectsLimit: Int = 0
    
    // MARK: - FileManager properties

    private var imagePathFromID: (String) -> URL? = { name in
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        return directory?.appendingPathComponent("\(name).jpg")
    }
    
    // MARK: - CoreData properties
    
    private lazy var userContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ImageDataModel")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                print("ERROR: \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    private var currentContext: NSManagedObjectContext { userContainer.viewContext }
    
    // MARK: - Service interface
    
    func setObjectsLimit(value: Int) {
        objectsLimit = value > 0 ? value : 0
    }
    
    func cutByLimitIfNeeded() {
        if let IDs = attemptToRemoveOldestMetadata() {
            for id in IDs {
                attemptToRemoveImageData(with: id)
            }
        }
    }
    
    func fetchIDList() -> UUID // set
    
    func fetchPromptByID() -> [String] {
        guard let metadataList = attemptTofetchAllImagesMetaData() else { return [] }
        return metadataList.compactMap { $0.promt }
    }
    
    func saveImageItemModel(model: ImageItemModel, timeStamp: Date, id: UUID) {
        if attemptToSaveImageObject(id: id, timeStamp: timeStamp, prompt: model.prompt) {
            attempToSaveImageData(data: model.imageData, with: id)
        }
    }
    
    func fetchAllSortedImageItemModels() -> [ImageItemModel] {
        guard let metadataList = attemptTofetchAllImagesMetaData() else { return [] }
        var modelsList: [ImageItemModel] = []
        
        for metadata in metadataList {
            guard let id = metadata.id else { continue }
            guard let prompt = metadata.promt else { continue }
            guard let imageData = attemptToFetchImageData(with: id) else { continue }
            
            modelsList.append(ImageItemModel(imageData: imageData, prompt: prompt))
        }
        
        return modelsList
    }
    
    func removeAllData() {
        attemptToDeleteAllData()
    }
    
  
    // MARK: - FileManager methods
    
    private func attemptToFetchImageData(with id: UUID) -> Data? {
        guard let imagePath = imagePathFromID(String(id.hashValue)) else { return nil }
        
        do {
            return try Data(contentsOf: imagePath)
        } catch {
            print("FILEMANAGER : FAILED TO FETCH \(id).jpg: \(error.localizedDescription)")
            return nil
        }
    }
    
    private func attemptToRemoveImageData(with id: UUID) {
        guard let imagePath = imagePathFromID(String(id.hashValue)) else { return }
        
        do {
            try FileManager.default.removeItem(at: imagePath)
        } catch {
            print("FILEMANAGER : FAILED TO REMOVE \(id).jpg: \(error.localizedDescription)")
        }
    }
    
    private func attempToSaveImageData(data: Data, with id: UUID) {
        guard let imagePath = imagePathFromID(String(id.hashValue)) else { return }
        
        do {
            try data.write(to: imagePath)
        } catch {
            print("FILEMANAGER : FAILED TO SAVE \(id.hashValue).jpg: \(error.localizedDescription)")
        }
    }

    // MARK: - CoreData methods
    
    private func attemptTofetchAllImagesMetaData() -> [ImageMetadata]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ImageMetadata")
        
        do {
            if let list = try currentContext.fetch(fetchRequest) as? [ImageMetadata], !list.isEmpty {
                return list
            } else {
                print("* COREDATA - EMPTY IMG METADATA MODELS")
                return nil
            }
        } catch {
            print("* COREDATA - FAILED TO FETCH ALL: \(error.localizedDescription)")
            return nil
        }
    }
    
    private func attemptToRemoveOldestMetadata() -> [UUID]? {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "ImageMetadata")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timeStamp", ascending: false)]
        
        do {
            guard let objects = try currentContext.fetch(fetchRequest) as? [ImageMetadata] else {
                throw NSError(domain: "Unknown type cast error", code: 0)
            }
            
            var imageDataIDs = [UUID]()
            
            if objects.count > objectsLimit {
                for i in 50..<objects.count {
                    if let id = objects[i].id {
                        imageDataIDs.append(id)
                        currentContext.delete(objects[i])
                    }
                }
            }
            
            return imageDataIDs
        } catch let error as NSError {
            print("* COREDATA SORTING ERROR : \(error.localizedDescription)")
            return nil
        }
    }
    
    private func attemptToSaveImageObject(id: UUID, timeStamp: Date, prompt: String) -> Bool {
        guard let entity = NSEntityDescription.entity(forEntityName: "ImageMetadata", in: currentContext) else {
            return false
        }
        
        let object = NSManagedObject(entity: entity, insertInto: currentContext)
        object.setValue(id.hashValue, forKey: "id")
        object.setValue(timeStamp, forKey: "timeStamp")
        object.setValue(prompt, forKey: "prompt")
        
        return contextSuccessfullySaved()
    }
    
    func attemptToDeleteAllData() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ImageMetadata")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            guard let entities = try currentContext.fetch(fetchRequest) as? [NSManagedObject] else {
                throw NSError(domain: "Unknown cast error", code: 0)
            }
            
            entities.forEach { currentContext.delete($0) }
            guard contextSuccessfullySaved() else { return }
            
            guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory,
                                                                       in: .userDomainMask).first else { return }
            let urls = try FileManager.default.contentsOfDirectory(at: documentsDirectory,
                                                                       includingPropertiesForKeys: nil)
            try urls.forEach { try FileManager.default.removeItem(at: $0) }
        } catch let error {
            print("DELETING ERROR : \(error)")
        }
    }
    
    private func contextSuccessfullySaved() -> Bool {
        if currentContext.hasChanges {
            do {
                try currentContext.save()
                return true
            } catch {
                currentContext.rollback()
                print("* COREDATA - SAVING ERROR: \(error.localizedDescription)")
            }
        }
        return false
    }
}
