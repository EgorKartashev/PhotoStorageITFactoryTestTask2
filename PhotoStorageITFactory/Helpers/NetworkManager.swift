
import Foundation
import UIKit

enum Constant {
    static let numberOfCells = 10
    static let favorirephotoSystemImage: String = "star.fill"
    static let unFavorirephotoSystemImage: String = "star"
}

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    var albumId = 1
    
    private init() {}
    
    func fetchPhotos(albumID: Int, completion: @escaping (Result<[Photo], Error>) -> Void) {
        guard let url = URL(string: R.Url.urlJson) else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print(R.Errors.errorFetch + "\(error)")
                completion(.failure(error))
                return
            }
            guard let data = data else {return}
            do {
                let photos = try JSONDecoder().decode([Photo].self, from: data)
                let photosForAlbum = photos.filter { $0.albumId == self.albumId }
                completion(.success(photosForAlbum))
                self.albumId += 1
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
        if !photo.isFavorite{
            cell.starImageView.image = UIImage(systemName: Constant.unFavorirephotoSystemImage)
        } else {
            cell.starImageView.image = UIImage(systemName: Constant.favorirephotoSystemImage)
        }
        if let cachedImage = ImageCache.shared.getImage(forKey: photo.thumbnailUrl) {
            DispatchQueue.main.async {
                cell.photoImageView.image = cachedImage
                cell.titleLabel.text = photo.title
            }
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
    
    func configureCell(cell: FavoritePhotoCollectionViewCell, photo: Photo) {
        if !photo.isFavorite{
            cell.starImageView.image = UIImage(systemName: Constant.unFavorirephotoSystemImage)
        } else {
            cell.starImageView.image = UIImage(systemName: Constant.favorirephotoSystemImage)
        }
        if let cachedImage = ImageCache.shared.getImage(forKey: photo.thumbnailUrl) {
            DispatchQueue.main.async {
                cell.photoImageView.image = cachedImage
                cell.titleLabel.text = photo.title
            }
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
