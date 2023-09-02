
import Foundation
import UIKit

private enum Constant {
    static let numberOfCells = 10
    static let favorirephotoSystemImage: String = "star.fill"
    static let unFavorirephotoSystemImage: String = "star"
}

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    var albumId = 1
    
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
                let photosForAlbum = photos.filter { $0.albumId == self.albumId }
                DispatchQueue.main.async {
                    completion(.success(photosForAlbum))
                    self.albumId += 1
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
                loadImage(photo: photo) { result in
                    switch result {
                    case .success(let image):
                        ImageCache.shared.setImage(image, forKey: photo.thumbnailUrl)
                        DispatchQueue.main.async {
                            cell.photoImageView.image = image
                            cell.titleLabel.text = photo.title
                        }
                    case .failure(let error):
                        // СДЕЛАТЬ АЛЕРТ?
                        print("Alert ошибка получения данных", error.localizedDescription)
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
                loadImage(photo: photo) { result in
                    switch result {
                    case .success(let image):
                        ImageCache.shared.setImage(image, forKey: photo.thumbnailUrl)
                        DispatchQueue.main.async {
                            cell.photoImageView.image = image
                            cell.titleLabel.text = photo.title
                        }
                    case .failure(let error):
                        // СДЕЛАТЬ АЛЕРТ?
                        print("Alert ошибка получения данных", error.localizedDescription)
                    }
                }
            }
        }
    }
}
