import Foundation
import UIKit

// MARK: - Favorites tab presenter protocol

protocol FavoritesTabInput {
    func viewDidLoaded()
    
    func selectedItem(_ value: ImageItemModel)
    func tappedInfoButton()
}

// MARK: - Favorites tab presenter

final class FavoritesTabPresenter {
    
    private var view: FavoritesTabOutput?
    private var model: FavoritesTabStateModel = .message(Constants.Text.Favorites_Tab.emptyListText)
    
}

// MARK: - Favorites tab view input

extension FavoritesTabPresenter: FavoritesTabInput {
    func viewDidLoaded() {
        view = DependencyContainer.shared.resolve(type: FavoritesTabOutput.self)
        view?.updateState(with: model)
        
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
    
    func selectedItem(_ value: ImageItemModel) {
        print(value)
    }
    
    func tappedInfoButton() {
        // change image
        // hide table view and show message
    }
}
