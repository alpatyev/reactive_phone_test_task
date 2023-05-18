import Foundation

// MARK: - Favorites tab presenter protocol

protocol FavoritesTabInput {
    func viewDidLoaded()
}

// MARK: - Favorites tab presenter

final class FavoritesTabPresenter {
    
    private var view: FavoritesTabOutput?
    private var model: FavoritesTabStateModel = .empty(Constants.Text.Favorites_Tab.emptyListText)
    
}

// MARK: - Favorites tab view input

extension FavoritesTabPresenter: FavoritesTabInput {
    func viewDidLoaded() {
        view = DependencyContainer.shared.resolve(type: FavoritesTabOutput.self)
        view?.updateState(with: model)
    }
}
