import Foundation

// MARK: - Image URL builder

final class ImageURLBuilder {
    
    static fileprivate let flickrApiKey = "7eb6b116106d7c9d5661d72d0b5bfc76"

    static func imagesListURL(_ name: String) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.flickr.com"
        components.path = "/services/rest/"
        components.queryItems = [
            URLQueryItem(name: "method", value: "flickr.photos.search"),
            URLQueryItem(name: "api_key", value: ImageURLBuilder.flickrApiKey),
            URLQueryItem(name: "text", value: name),
            URLQueryItem(name: "sort", value: "relevance"),
            URLQueryItem(name: "per_page", value: "1"),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "nojsoncallback", value: "1")]
        return components.url
    }
    
    static func imageURL(server: String, id: String, secret: String) -> URL? {
        URL(string: "https://live.staticflickr.com/\(server)/\(id)_\(secret)_m.jpg")
    }
}
