import Foundation
import UIKit

// MARK: - Favorites tab presenter protocol

protocol FavoritesTabInput {
    func viewDidLoaded()
    func viewAppeared()
    func viewDisappeared()
    func reportedDisplayedItemsCount(_ count: Int)
    
    func selectedItem(_ value: ImageItemModel)
    func tappedInfoButton()
}

// MARK: - Favorites tab presenter

final class FavoritesTabPresenter {
    private var itemsCountMessage = String()
    private var view: FavoritesTabOutput?
    private var storageService: StorageDataServiceProtocol?
    private var currentStatusMessage = Constants.Text.Favorites_Tab.emptyListText
    private var stateModel: FavoritesTabStateModel = .message(String())
    private var helperButtonStateModel: NavigationBarInfoButtonStateModel = .list
}

// MARK: - Favorites tab view input

extension FavoritesTabPresenter: FavoritesTabInput {
    func viewDidLoaded() {
        storageService = DependencyContainer.shared.resolve(type: StorageDataServiceProtocol.self)
        view = DependencyContainer.shared.resolve(type: FavoritesTabOutput.self)
        view?.updateNavigationBarState(with: .list)
        view?.updateState(with: stateModel)
    }
    
    func viewAppeared() {
        DispatchQueue.main.async { [weak self] in
            if let items = self?.storageService?.fetchAllSortedImageItemModels(), !items.isEmpty {
                self?.view?.updateState(with: .itemList(items))
            } else {
                self?.view?.updateState(with: .itemList([]))
                self?.view?.updateState(with: .message(Constants.Text.Favorites_Tab.emptyListText))
            }
        }
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
                helperButtonStateModel = .info(itemsCountMessage)
            case .info(_):
                helperButtonStateModel = .list
        }
        
        view?.updateNavigationBarState(with: helperButtonStateModel)
    }
    
    func reportedDisplayedItemsCount(_ count: Int) {
        if count == 0 {
            view?.updateState(with: .message(Constants.Text.Favorites_Tab.emptyListText))
        }
        
        itemsCountMessage = Constants.Text.Favorites_Tab.showInfo(count, Constants.Logic.imageItemsLimit)
        storageService?.cutByLimitIfNeeded(count)
    }
}
