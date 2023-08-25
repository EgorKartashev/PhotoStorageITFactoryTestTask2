
import Foundation
import UIKit

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchPhotos(completion: @escaping ([Photo]?) -> Void) {
        guard let url = URL(string: R.Url.urlJson) else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print(R.Errors.errorFetch + "\(error)")
                return
            }
            guard let data = data else {return}
            
            do {
                let photos = try JSONDecoder().decode([Photo].self, from: data)
                completion(photos)
            } catch {
                print(R.Errors.errorDecod + "\(error)")
            }
        }.resume()
    }
    
    func loadImage(photo: Photo, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: photo.url) else { return }
        let urlSession = URLSession.shared
        let dataTask = urlSession.dataTask(with: url) { data, _, error in
            if let error = error {
                print(R.Errors.errorLoad + "\(error)")
                completion(nil)
                return
            }
            if let imageData = data, let image = UIImage(data: imageData) {
                completion(image)
            } else {
                print(error?.localizedDescription ?? R.Errors.errorLoad)
            }
        }
        dataTask.resume()
    }
    
    func configureCell(cell: PhotoCollectionViewCell, photo: Photo) {
        if let cachedImage = ImageCache.shared.getImage(forKey: photo.thumbnailUrl) {
            cell.photoImageView.image = cachedImage
            cell.titleLabel.text = photo.title
        } else {
            loadImage(photo: photo) { image in
                guard let image = image else { return }
                ImageCache.shared.setImage(image, forKey: photo.thumbnailUrl)
                DispatchQueue.main.async {
                    cell.photoImageView.image = image
                    cell.titleLabel.text = photo.title
                }
            }
        }
    }
}
