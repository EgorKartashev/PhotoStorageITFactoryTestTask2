
import Foundation
import UIKit

protocol FavoritePhotoViewModelProtocol {
    var favoritePhotos: [Photo] { get set }
    func viewDidLoad()
}

final class FavoritePhotoViewModel: FavoritePhotoViewModelProtocol {

    var favoritePhotos: [Photo]
    //var updateUI: (() -> Void)?
    
    init(photos: [Photo]) {
        self.favoritePhotos = photos
    }
    
    
    func viewDidLoad() {
//        favoritePhotos.removeAll {$0.isFavorite == false}
//        print(favoritePhotos.count)
    }
}
