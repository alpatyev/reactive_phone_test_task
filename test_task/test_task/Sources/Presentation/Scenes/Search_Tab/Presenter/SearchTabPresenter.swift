import Foundation

// MARK: - Search tab presenter protocol

protocol SearchTabInput {
    func viewDidLoaded()
    func tappedSomewhere()
}

// MARK: - Search tab selected image protocol

protocol SearchTabSelectedImageInput {
    func selectedImage()
}

// MARK: - Search tab presenter

final class SearchTabPresenter {
    
    private weak var view: SearchTabOutput?
    
}

// MARK: - Search tab output impl

extension SearchTabPresenter: SearchTabInput {
    func viewDidLoaded() {
        view = DependencyContainer.shared.resolve(type: SearchTabOutput.self)
    }
    
    func tappedSomewhere() {
        DispatchQueue.main.async { [weak self] in
            self?.view?.closeKeyboard()
        }
    }
}


// MARK: - Search tab selected image impl

extension SearchTabPresenter: SearchTabSelectedImageInput {
    func selectedImage() {
        print(#function)
    }
}
