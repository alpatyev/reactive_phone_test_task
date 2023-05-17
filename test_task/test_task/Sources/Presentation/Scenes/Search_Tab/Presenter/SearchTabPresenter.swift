import Foundation

// MARK: - Search tab presenter protocol

protocol SearchTabInput {}

// MARK: - Search tab selected image protocol

protocol SearchTabSelectedImageInput {
    func selectedImage()
}

// MARK: - Search tab presenter

final class SearchTabPresenter: SearchTabInput {}

// MARK: - Search tab selected image impl

extension SearchTabPresenter: SearchTabSelectedImageInput {
    func selectedImage() {
        print(#function)
    }
}
