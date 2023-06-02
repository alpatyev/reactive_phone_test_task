import Foundation

// MARK: - Search tab state model

enum SearchTabStateModel {
    case noImage(String)
    case loading
    case loadedImage(Data)
}
