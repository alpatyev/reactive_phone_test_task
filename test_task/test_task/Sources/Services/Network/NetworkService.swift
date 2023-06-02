import Foundation
import SystemConfiguration

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

// MARK: - Helper for network connection status

final class NetworkReachability {
    
    private init() {}
    
    static func isConnected() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else { return false }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) { return false }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        
        return (isReachable && !needsConnection)
    }
}
