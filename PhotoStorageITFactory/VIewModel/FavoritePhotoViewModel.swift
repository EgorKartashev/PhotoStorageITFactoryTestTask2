
import Foundation
import UIKit

final class FavoritePhotoViewModele {
    var photo: Photo
    var favoritePhotos:[Photo] = []
    
    init(photo: Photo) {
        self.photo = photo
    }
    
    func loadImage(completion: @escaping (UIImage?) -> Void) {
        NetworkManager.shared.loadImage(photo: photo) { image in
            completion(image)
        }
    }
    
    func addToFavotirePhotos(photo: Photo){
        if !favoritePhotos.contains(photo){
            self.favoritePhotos.append(photo)
        }
    }
    
    func removeFromFavoritePhotos(photo: Photo) {
        if let index = favoritePhotos.firstIndex(of: photo) {
            favoritePhotos.remove(at: index)
        }
    }
}
