import Foundation

// MARK: - Favorites tab state model

enum FavoritesTabStateModel {
    case message(String)
    case itemList([ImageItemModel])
}
