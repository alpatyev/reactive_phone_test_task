import Foundation

// MARK: - Favorites tab state model

enum FavoritesTabStateModel {
    case empty(String)
    case itemList([Data])
}
