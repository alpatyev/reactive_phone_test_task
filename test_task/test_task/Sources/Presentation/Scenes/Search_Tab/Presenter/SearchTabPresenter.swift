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
    func selectedImage()
}

// MARK: - Search tab presenter

final class SearchTabPresenter {
    
    private weak var view: SearchTabOutput?
    private var model = SearchTabStateModel.noImage(Constants.Text.Search_Tab.imageDefaultLabel)
    
}

// MARK: - Search tab output impl

extension SearchTabPresenter: SearchTabInput {
    func viewDidLoaded() {
        view = DependencyContainer.shared.resolve(type: SearchTabOutput.self)
        view?.updateState(with: model)
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
        print(searchText)
        view?.closeKeyboard()
    }
}

// MARK: - Search tab selected image impl

extension SearchTabPresenter: SearchTabSelectedImageInput {
    func selectedImage() {
        print(#function)
    }
}
