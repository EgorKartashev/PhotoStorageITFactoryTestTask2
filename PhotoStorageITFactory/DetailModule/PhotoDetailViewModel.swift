
import Foundation
import UIKit

protocol PhotoDetailViewModelProtocol {
    var photo: Photo { get }
    func loadImage(completion: @escaping (UIImage?) -> Void)
}

protocol PhotoDetailViewModelDelegate: AnyObject {
    func photoDetailViewModelDidUpdateFavoriteState(viewModel: PhotoDetailViewModel, isFavorite: Bool)
}

final class PhotoDetailViewModel: PhotoDetailViewModelProtocol {
    var photo: Photo
    weak var delegate: PhotoDetailViewModelDelegate?
    
    init(photo: Photo) {
        self.photo = photo
    }
    
    func loadImage(completion: @escaping (UIImage?) -> Void) {
        NetworkManager.shared.loadImage(photo: photo) { result in
            switch result {
            case .success(let image):
                completion(image)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func favoriteButtonPressed(){
        toggleFavorite()
        updateFavoriteButtonState()
    }
    
    func toggleFavorite() {
        photo.isFavorite.toggle()
        if photo.isFavorite {
            var favoritePhotoIDs = UserDefaults.standard.stringArray(forKey: Resources.KeyUserDefaults.favoritePhotoIDs) ?? []
            favoritePhotoIDs.append(String(photo.id))
            UserDefaults.standard.set(favoritePhotoIDs, forKey: Resources.KeyUserDefaults.favoritePhotoIDs)
            // УБРАТЬ
            print(favoritePhotoIDs)
        } else {
            var favoritePhotoIDs = UserDefaults.standard.stringArray(forKey: Resources.KeyUserDefaults.favoritePhotoIDs) ?? []
            if let index = favoritePhotoIDs.firstIndex(of: String(photo.id)) {
                favoritePhotoIDs.remove(at: index)
                UserDefaults.standard.set(favoritePhotoIDs, forKey: Resources.KeyUserDefaults.favoritePhotoIDs)
                // УБРАТЬ
                print(favoritePhotoIDs)
            }
        }
        delegate?.photoDetailViewModelDidUpdateFavoriteState(viewModel: self, isFavorite: photo.isFavorite)
    }
    
    func updateFavoriteButtonState() {
        let isFavorite = photo.isFavorite
        delegate?.photoDetailViewModelDidUpdateFavoriteState(viewModel: self, isFavorite: isFavorite)
    }
    
}
