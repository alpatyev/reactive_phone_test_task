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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            guard let img = UIImage(named: "star.fill") else { return }
            guard let data = img.pngData() else { return }
            
            self.view?.updateState(with: .itemList([ImageItemModel(imageData: data,
                                                                   timeStamp: Date(),
                                                                   prompt: "1209832-1059874-39857-9258709823709827540"),
                                                    ImageItemModel(imageData: data,
                                                                   timeStamp: Date(),
                                                                   prompt: "1209832-1059874-39857-9258709823709827540"),
                                                    ImageItemModel(imageData: data,
                                                                   timeStamp: Date(),
                                                                   prompt: "1209832-1059874-39857-9258709823709827540"),
                                                    ImageItemModel(imageData: data,
                                                                   timeStamp: Date(),
                                                                   prompt: "1209832-1059874-39857-9258709823709827540")]))
        }
    }
    
    func viewDisappeared() {
        view?.toggleUserInteractions(with: true)
    }
    
    func selectedItem(_ value: ImageItemModel) {
        print(value)
        view?.toggleUserInteractions(with: false)
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
