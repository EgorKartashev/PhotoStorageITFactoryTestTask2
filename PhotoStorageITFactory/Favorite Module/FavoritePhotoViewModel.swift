
import Foundation
import UIKit

protocol FavoritePhotoViewModelProtocol {
    var favoritePhotos: [Photo] { get }
}

final class FavoritePhotoViewModel: FavoritePhotoViewModelProtocol {
    
    var favoritePhotos:[Photo] = []
    var mainViewModel : MainViewModelProtocol
    var updateUI: (() -> Void)?
    
    init(mainViewModel: MainViewModelProtocol) {
        
        self.mainViewModel = mainViewModel
    }
    
    func refreshPhotos() {
        let favoritePhotoIDs = UserDefaults.standard.stringArray(forKey: "favoritePhotoIDs") ?? []
        favoritePhotos = favoritePhotoIDs.compactMap { id in
            if let idInt = Int(id), let photo = mainViewModel.photos.first(where: { $0.id == idInt }) {
                return photo
            } else {return nil}
        }
        print(favoritePhotos)
    }
    
}
