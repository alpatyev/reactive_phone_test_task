import Foundation

// MARK: - Search tab presenter protocol

protocol SearchTabInput {
    func viewDidLoaded()
    
    func tappedSomewhere()
    func saveButtonTapped()
    func removeButtonTapped()
    func clearAllDataButtonTapped()
    
    func textFieldReturned(_ value: String?)
}

// MARK: - Search tab selected image protocol

protocol SearchTabSelectedImageInput {
    func selectedImage(item: ImageItemModel)
}

// MARK: - Search tab presenter

final class SearchTabPresenter {
    
    private weak var view: SearchTabOutput?
    private var networkService: NetworkServiceProtocol?
    private var storageService: StorageDataServiceProtocol?
    private var imageItemModel = ImageItemModel(id: UUID(), imageData: Data(), prompt: String())

    private var isRemoveButtonEnabled = true {
        didSet {
            view?.setRemoveButtonEnabled(isRemoveButtonEnabled)
        }
    }
    
    private var stateModel = SearchTabStateModel.noImage(String()) {
        didSet {
            view?.updateState(with: stateModel)
        }
    }
}

// MARK: - Search tab output impl

extension SearchTabPresenter: SearchTabInput {
    func viewDidLoaded() {
        networkService = DependencyContainer.shared.resolve(type: NetworkServiceProtocol.self)
        storageService = DependencyContainer.shared.resolve(type: StorageDataServiceProtocol.self)
                
        view = DependencyContainer.shared.resolve(type: SearchTabOutput.self)
        stateModel = SearchTabStateModel.noImage(Constants.Text.Search_Tab.imageDefaultLabel)
    }
    
    func tappedSomewhere() {
        DispatchQueue.main.async { [weak self] in
            self?.view?.closeKeyboard()
        }
    }
    
    func saveButtonTapped() {
        DispatchQueue.main.async { [weak self] in
            if let model = self?.imageItemModel,
               let storageServicePointer = self?.storageService,
                !storageServicePointer.containsID(with: model.id) {
                storageServicePointer.saveImageItemModel(model: model, timeStamp: Date())
            }
            self?.isRemoveButtonEnabled = true
        }
    }
    
    func removeButtonTapped() {
        isRemoveButtonEnabled = false
        storageService?.removeImageData(with: imageItemModel.id)
    }
    
    func clearAllDataButtonTapped() {
        isRemoveButtonEnabled = false
        storageService?.removeAllData()
    }
    
    func textFieldReturned(_ value: String?) {
        guard let searchText = value else { return }
        let trimmedPrompt = searchText.trimmingCharacters(in: .whitespaces)
        guard cannotUpdateFromCoreData(with: trimmedPrompt) else { view?.closeKeyboard(); return }
        
        stateModel = .loading
        print(searchText)
        networkService?.fetchImage(with: trimmedPrompt) { [weak self] data in
            DispatchQueue.main.async {
                if let imageData = data {
                    self?.imageItemModel = ImageItemModel(id: UUID(), imageData: imageData, prompt: trimmedPrompt)
                    self?.stateModel = .loadedImage(imageData)
                    self?.isRemoveButtonEnabled = false
                } else {
                    self?.stateModel = .noImage(Constants.Text.Search_Tab.noImageFounded)
                }
            }
        }
        view?.closeKeyboard()
    }
    
    private func cannotUpdateFromCoreData(with propmpt: String) -> Bool {
        if let model = storageService?.fetchImageItemModel(with: propmpt) {
            imageItemModel = model
            stateModel = .loadedImage(model.imageData)
            return false
        } else {
            return true
        }
    }
}

// MARK: - Search tab selected image impl

extension SearchTabPresenter: SearchTabSelectedImageInput {
    func selectedImage(item: ImageItemModel) {
        imageItemModel = item
        stateModel = .loadedImage(item.imageData)
    }
}
