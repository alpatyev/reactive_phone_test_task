import Foundation

// MARK: - Network service protocol

protocol NetworkServiceProtocol: AnyObject {
    func fetchImage(with prompt: String, _ completion: @escaping (Data?) -> ())
}

// MARK: - Network service

final class NetworkService: NetworkServiceProtocol {
        
    private let session = URLSession.shared
    
    func fetchImage(with prompt: String, _ completion: @escaping (Data?) -> ()) {
        fetchFirstMatchingImageMetadata(with: prompt) { [weak self] result in
            if let metadata = result {
                self?.downloadImageData(with: metadata) { completion($0) }
            } else {
                completion(nil)
            }
        }
    }

    private func fetchFirstMatchingImageMetadata(with prompt: String, _ completion: @escaping (FlickrPhotoMetadata?) -> ()) {
        guard let url = ImageURLBuilder.imagesListURL(prompt) else {
            completion(nil)
            return
        }
        
        session.dataTask(with: url) { data, _, _ in
            do {
                if let flickrResponseData = data {
                    let decoded = try JSONDecoder().decode(FlickrResponseData.self, from: flickrResponseData)
                    completion(decoded.photos?.list.first)
                }
            } catch let error {
                print("* NETWORK SERVICE ERROR: \(error.localizedDescription)")
            }
            completion(nil)
        }.resume()
    }
    
    private func downloadImageData(with metadata: FlickrPhotoMetadata, _ completion: @escaping (Data?) -> ()) {
        guard let url = ImageURLBuilder.imageURL(server: metadata.server, id: metadata.id, secret: metadata.secret) else {
            completion(nil)
            return
        }
        
        session.dataTask(with: url) { data, _, _ in
            completion(data)
        }.resume()
    }
}
