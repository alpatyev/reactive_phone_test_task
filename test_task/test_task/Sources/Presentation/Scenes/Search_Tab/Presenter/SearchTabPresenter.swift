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
    private var model = SearchTabStateModel.noImage(Constants.Text.Search_Tab.imageDefaultText)
    
}

// MARK: - Search tab output impl

extension SearchTabPresenter: SearchTabInput {
    func viewDidLoaded() {
        view = DependencyContainer.shared.resolve(type: SearchTabOutput.self)
        view?.updateState(with: model)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.view?.updateState(with: .loading)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
            self.view?.updateState(with: .noImage("ss"))
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 16) {
            self.view?.updateState(with: .loadedImage(Data()))
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 20) {
            self.view?.updateState(with: .loading)
        }
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
