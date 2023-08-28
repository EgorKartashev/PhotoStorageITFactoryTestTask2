
import Foundation
import UIKit

protocol PhotoDetailViewModelProtocol {
    var photo: Photo { get }
    func loadImage(completion: @escaping (UIImage?) -> Void)
}

protocol PhotoDetailViewModelDelegate: AnyObject {
    func photoDetailViewModelDidUpdateFavoriteState(viewModel: PhotoDetailViewModel)
}

final class PhotoDetailViewModel: PhotoDetailViewModelProtocol {
    var photo: Photo
    weak var delegate: PhotoDetailViewModelDelegate?
    
    init(photo: Photo) {
        self.photo = photo
    }
    
    func loadImage(completion: @escaping (UIImage?) -> Void) {
        NetworkManager.shared.loadImage(photo: photo) { image in
            completion(image)
        }
    }
    
    func toggleFavorite() {
        photo.isFavorite.toggle()
        if photo.isFavorite {
            var favoritePhotoIDs = UserDefaults.standard.stringArray(forKey: "favoritePhotoIDs") ?? []
            favoritePhotoIDs.append(String(photo.id))
            UserDefaults.standard.set(favoritePhotoIDs, forKey: "favoritePhotoIDs")
        } else {
            var favoritePhotoIDs = UserDefaults.standard.stringArray(forKey: "favoritePhotoIDs") ?? []
            if let index = favoritePhotoIDs.firstIndex(of: String(photo.id)) {
                favoritePhotoIDs.remove(at: index)
                UserDefaults.standard.set(favoritePhotoIDs, forKey: "favoritePhotoIDs")
            }
        }
        delegate?.photoDetailViewModelDidUpdateFavoriteState(viewModel: self)
    }
    
    
}
