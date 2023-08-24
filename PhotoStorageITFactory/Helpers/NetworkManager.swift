
import Foundation
import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}

    func fetchPhotos(completion: @escaping ([Photo]?) -> Void) {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/photos") else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error fetching data: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                let photos = try JSONDecoder().decode([Photo].self, from: data)
                completion(photos)
            } catch {
                print("Error decoding data: \(error)")
                completion(nil)
            }
        }.resume()
    }
    
    func loadImage(photo: Photo, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: photo.url) else {
            completion(nil)
            return
        }
        
        let urlSession = URLSession.shared
        let dataTask = urlSession.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error loading image: \(error)")
                completion(nil)
                return
            }
            
            if let imageData = data, let image = UIImage(data: imageData) {
                completion(image)
            } else {
                completion(nil)
            }
        }
        
        dataTask.resume()
    }
}
