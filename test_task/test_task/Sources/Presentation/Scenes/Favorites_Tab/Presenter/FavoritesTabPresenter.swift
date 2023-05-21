import Foundation
import UIKit

// MARK: - Favorites tab presenter protocol

protocol FavoritesTabInput {
    func viewDidLoaded()
    func viewAppearedWithElements(_ count: Int)
    func viewDisappeared()
    
    func selectedItem(_ value: ImageItemModel)
    func tappedInfoButton()
}

// MARK: - Favorites tab presenter

final class FavoritesTabPresenter {
    
    private var currentItemsCount: Int = 0
    
    private var view: FavoritesTabOutput?
    private var storageService: StorageDataServiceProtocol?
    
    private var stateModel: FavoritesTabStateModel = .message(String()) {
        didSet {
            view?.updateState(with: stateModel)
        }
    }
    
    private var helperButtonStateModel: NavigationBarInfoButtonStateModel = .list {
        didSet {
            view?.updateNavigationBarState(with: helperButtonStateModel)
        }
    }
}

// MARK: - Favorites tab view input

extension FavoritesTabPresenter: FavoritesTabInput {
    func viewDidLoaded() {
        storageService = DependencyContainer.shared.resolve(type: StorageDataServiceProtocol.self)
        view = DependencyContainer.shared.resolve(type: FavoritesTabOutput.self)
        
        view?.updateNavigationBarState(with: .list)
        view?.updateState(with: stateModel)
    }
    
    func viewAppearedWithElements(_ count: Int) {
        updateList(count)
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
                stateModel = .message(Constants.Text.Favorites_Tab.showInfo(currentItemsCount, Constants.Logic.imageItemsLimit))
                helperButtonStateModel = .info
            case .info:
                helperButtonStateModel = .list
                updateList(currentItemsCount)
        }
        
    }
    
    private func updateList(_ count: Int) {
        if count == 0 { stateModel = .message(Constants.Text.Favorites_Tab.emptyListText) }
        helperButtonStateModel = .list
        
        DispatchQueue.main.async { [weak self] in
            if let items = self?.storageService?.fetchAllSortedImageItemModels(), !items.isEmpty {
                self?.currentItemsCount = items.count
                self?.stateModel = .itemList(Array(items.prefix(Constants.Logic.imageItemsLimit)))
                self?.storageService?.cutByLimitIfNeeded(items.count)
            } else {
                self?.currentItemsCount = 0
                self?.stateModel = .message(Constants.Text.Favorites_Tab.emptyListText)
                self?.view?.removeItemData()
            }
        }
    }
}
