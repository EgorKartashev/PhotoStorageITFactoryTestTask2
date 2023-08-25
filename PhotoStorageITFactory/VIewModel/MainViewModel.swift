
import Foundation

final class MainViewModel {
    
    var photos: [Photo] = []
    var updateUI: (() -> Void)?
    
    func photoTitle(at index: Int) -> String {
        photos[index].title
    }
    
    func fetchPhotos() {
        NetworkManager.shared.fetchPhotos { [weak self] photos in
            if let photos = photos {
                self?.photos.append(contentsOf: photos)
                self?.updateUI?()
            }
        }
    }
}
