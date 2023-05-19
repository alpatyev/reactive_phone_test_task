import Foundation

// MARK: - Search tab presenter protocol

protocol SearchTabInput {
    func viewDidLoaded()
    
    func tappedSomewhere()
    func saveButtonTapped()
    func removeButtonTapped()
    func randomButtonTapped()
    
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
    private var stateModel = SearchTabStateModel.noImage(String()) {
        didSet {
            print(stateModel)
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
        print(#function)
    }
    
    func removeButtonTapped() {
        print(#function)
    }
    
    func randomButtonTapped() {
        print(#function)
    }
    
    func textFieldReturned(_ value: String?) {
        guard let searchText = value else { return }
        
        stateModel = .loading
        networkService?.fetchImage(with: searchText.trimmingCharacters(in: .whitespaces)) { [weak self] data in
            DispatchQueue.main.async {
                if let imageData = data {
                    self?.stateModel = .loadedImage(imageData)
                } else {
                    self?.stateModel = .noImage(String())
                }
            }
        }
        
        view?.closeKeyboard()
    }
}

// MARK: - Search tab selected image impl

extension SearchTabPresenter: SearchTabSelectedImageInput {
    func selectedImage(item: ImageItemModel) {
        stateModel = .loadedImage(item.imageData)
    }
}
