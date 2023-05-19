import Foundation

// MARK: - Photos search models

struct FlickrResponseData: Decodable {
    let photos: FlickrPhotosResult?
}

struct FlickrPhotosResult: Decodable {
    let list: [FlickrPhotoMetadata]
    
    enum CodingKeys: String, CodingKey {
        case list = "photo"
    }
}

struct FlickrPhotoMetadata: Decodable {
    let id: String
    let secret: String
    let server: String
}
