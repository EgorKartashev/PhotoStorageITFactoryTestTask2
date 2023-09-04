import Foundation
import UIKit

protocol FavoritePhotoViewModelProtocol {
    var favoritePhotos: [Photo] { get set }
}

final class FavoritePhotoViewModel: FavoritePhotoViewModelProtocol {
    
    var favoritePhotos: [Photo]
    
    init(photos: [Photo]) {
        self.favoritePhotos = photos
    }
    
    
}
