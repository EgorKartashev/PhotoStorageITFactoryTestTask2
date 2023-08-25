
import Foundation
import UIKit

final class PhotoDetailViewModel {
    var photo: Photo
    
    init(photo: Photo) {
        self.photo = photo
    }
    
    func loadImage(completion: @escaping (UIImage?) -> Void) {
        NetworkManager.shared.loadImage(photo: photo) { image in
            completion(image)
        }
    }
}
