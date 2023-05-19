import Foundation
import UIKit

// MARK: - Favorites tab presenter protocol

protocol FavoritesTabInput {
    func viewDidLoaded()
    func viewDisappeared()
    func selectedItem(_ value: ImageItemModel)
    func tappedInfoButton()
}

// MARK: - Favorites tab presenter

final class FavoritesTabPresenter {
    private var view: FavoritesTabOutput?
    private var stateModel: FavoritesTabStateModel = .message(Constants.Text.Favorites_Tab.emptyListText)
    private var helperButtonStateModel: NavigationBarInfoButtonStateModel = .list
}

// MARK: - Favorites tab view input

extension FavoritesTabPresenter: FavoritesTabInput {
    func viewDidLoaded() {
        view = DependencyContainer.shared.resolve(type: FavoritesTabOutput.self)
        view?.updateNavigationBarState(with: .list)
        view?.updateState(with: stateModel)
        
        view?.updateState(with: .itemList([ImageItemModel(imageData: (UIImage(named: "star.fill")?.pngData())!, prompt: "хуй")]))
    }
    
    func viewDisappeared() {
        view?.toggleUserInteractions(with: true)
    }
    
    func selectedItem(_ value: ImageItemModel) {
        view?.toggleUserInteractions(with: false)
        
        if let tabPresenter = DependencyContainer.shared.resolve(type: SearchTabSelectedImageInput.self) {
            tabPresenter.selectedImage(item: value)
            view?.selectedTabBarIndex(0)
        }
    }
    
    func tappedInfoButton() {
        switch helperButtonStateModel {
            case .list:
                helperButtonStateModel = .info("всего 5 айтемов")
            case .info(_):
                helperButtonStateModel = .list
        }
        
        view?.updateNavigationBarState(with: helperButtonStateModel)
    }
}
