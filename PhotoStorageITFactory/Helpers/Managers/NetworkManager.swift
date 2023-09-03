
import Foundation
import UIKit


final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchPhotos(albumID: Int, completion: @escaping (Result<[Photo], Error>) -> Void) {
        guard let url = URL(string: Resources.Url.urlJson) else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print(Resources.Errors.errorFetch + "\(error)")
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            guard let data = data else {return}
            do {
                let photos = try JSONDecoder().decode([Photo].self, from: data)
                let photosForAlbum = photos.filter { $0.albumId == albumID }
                DispatchQueue.main.async {
                    completion(.success(photosForAlbum))
                }
            } catch {
                DispatchQueue.main.async {
                    print(Resources.Errors.errorDecod + "\(error)")
                }
            }
        }.resume()
    }
    
    func loadImage(photo: Photo, completion: @escaping (Result<UIImage, Error>) -> Void) {
        guard let url = URL(string: photo.url) else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            if let imageData = data, let image = UIImage(data: imageData) {
                DispatchQueue.main.async {
                    completion(.success(image))
                }
            } else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "Image data error", code: 0, userInfo: nil)))
                }
            }
        }.resume()
    }
}

