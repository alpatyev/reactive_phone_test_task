import Foundation
import CoreData

// MARK: - Storage data service protocol

protocol StorageDataServiceProtocol: AnyObject {
    func cutByLimitIfNeeded(_ count: Int)

    func containsPrompt(with text: String) -> Bool
    func containsID(with value: UUID) -> Bool
    func fetchAllSortedImageItemModels() -> [ImageItemModel]
    func fetchImageItemModel(with id: UUID) -> ImageItemModel?
    
    func saveImageItemModel(model: ImageItemModel, timeStamp: Date)
    
    func removeImageData(with id: UUID)
    func removeAllData()
}

// MARK: - Storage data service

final class StorageDataService: StorageDataServiceProtocol {

    private var objectsLimit: Int = Constants.Logic.imageItemsLimit
    
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
    
    func cutByLimitIfNeeded(_ count: Int) {
        guard count > objectsLimit else { return }
        
        if let IDs = attemptToRemoveOldestMetadata() {
            for id in IDs {
                print(id)
                attemptToRemoveImageData(with: id)
            }
        }
    }
    
    func containsPrompt(with text: String) -> Bool {
        attemptTofetchAllImagesMetaData()?.contains { $0.prompt == text } ?? false
    }
    
    func containsID(with value: UUID) -> Bool {
        attemptTofetchAllImagesMetaData()?.contains { $0.id == value } ?? false
    }
    
    func fetchImageItemModel(with id: UUID) -> ImageItemModel? {
        guard let firstMatchObject = attemptSearchToByID(value: id) else { return nil }
        
        if let imageData = attemptToFetchImageData(with: id),
           let prompt = firstMatchObject.prompt,
           let id = firstMatchObject.id {
            return ImageItemModel(id: id, imageData: imageData, prompt: prompt)
        } else {
            return nil
        }
    }

    func fetchAllPrompts() -> [String] {
        guard let metadataList = attemptTofetchAllImagesMetaData() else { return [] }
        return metadataList.compactMap { $0.prompt }
    }
    
    func saveImageItemModel(model: ImageItemModel, timeStamp: Date) {
        if attemptToSaveImageObject(id: model.id, prompt: model.prompt, timeStamp: timeStamp) {
            attempToSaveImageData(data: model.imageData, with: model.id)
        }
    }
    
    func fetchAllSortedImageItemModels() -> [ImageItemModel] {
        guard let metadataList = attemptTofetchAllImagesMetaData() else { return [] }
        var modelsList: [ImageItemModel] = []
        
        for metadata in metadataList {
            guard let id = metadata.id else { continue }
            guard let prompt = metadata.prompt else { continue }
            guard let imageData = attemptToFetchImageData(with: id) else { continue }
            
            modelsList.append(ImageItemModel(id: id, imageData: imageData, prompt: prompt))
        }
        
        return modelsList
    }
    
    func removeImageData(with id: UUID) {
        attemptToRemoveImageData(with: id)
    }

    
    func removeAllData() {
        attemptToDeleteAllData()
    }
    
  
    // MARK: - FileManager methods
    
    private func attemptToFetchImageData(with id: UUID) -> Data? {
        guard let imagePath = imagePathFromID(id.uuidString) else { return nil }
        
        do {
            return try Data(contentsOf: imagePath)
        } catch {
            print("FILEMANAGER : FAILED TO FETCH \(id).jpg: \(error.localizedDescription)")
            return nil
        }
    }
    
    private func attemptToRemoveImageData(with id: UUID) {
        guard let imagePath = imagePathFromID(id.uuidString) else { return }
        
        do {
            try FileManager.default.removeItem(at: imagePath)
        } catch {
            print("FILEMANAGER : FAILED TO REMOVE \(id).jpg: \(error.localizedDescription)")
        }
    }
    
    private func attempToSaveImageData(data: Data, with id: UUID) {
        guard let imagePath = imagePathFromID(id.uuidString) else { return }
        
        do {
            try data.write(to: imagePath)
        } catch {
            print("FILEMANAGER : FAILED TO SAVE \(id.uuidString).jpg: \(error.localizedDescription)")
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
                print(objects.count, objectsLimit)
                for i in (objectsLimit - 1)..<objects.count {
                    if let id = objects[i].id {
                        imageDataIDs.append(id)
                        currentContext.delete(objects[i])
                    }
                }
            }
            
            if contextSuccessfullySaved() {
                return imageDataIDs
            }
        } catch let error as NSError {
            print("* COREDATA SORTING ERROR : \(error.localizedDescription)")
        }
        return nil
    }
    
    private func attemptToSaveImageObject(id: UUID, prompt: String, timeStamp: Date) -> Bool {
        guard let entity = NSEntityDescription.entity(forEntityName: "ImageMetadata", in: currentContext) else {
            return false
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let object = NSManagedObject(entity: entity, insertInto: currentContext)
        object.setValue(NSUUID(uuidString: id.uuidString), forKey: "id")
        object.setValue(dateFormatter.string(from: Date()), forKey: "timeStamp")
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
    
    private func attemptSearchToByID(value: UUID) -> ImageMetadata? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ImageMetadata")
        let predicate = NSPredicate(format: "id == %@", value.uuidString)
        fetchRequest.predicate = predicate
        
        do {
            if let entities = try currentContext.fetch(fetchRequest) as? [ImageMetadata] {
                return entities.first
            }
        } catch {
            print("SEARCH ERROR: \(error)")
        }
        
        return nil
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
