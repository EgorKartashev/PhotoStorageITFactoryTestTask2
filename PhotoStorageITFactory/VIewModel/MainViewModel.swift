
import Foundation



final class MainViewModel {
    
    var photos: [Photo] = []
    var updateUI: (() -> Void)?
    var onPhotoDetailRequested: ((PhotoDetailViewModel) -> Void)?
    var photosCount: Int {
        return photos.count
    }
    
    func photoTitle(at index: Int) -> String {
        return photos[index].title
    }
    
    func fetchPhotos() {
        NetworkManager.shared.fetchPhotos { [weak self] photos in
            if let photos = photos {
                self?.photos.append(contentsOf: photos)
                self?.updateUI?()
            }
        }
    }
    
    // ****** 1 ******
    
    func showPhotoDetail(at indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        let viewModel = PhotoDetailViewModel(photo: photo)
        onPhotoDetailRequested?(viewModel)
//        let vc = PhotoDetailViewController()
//        present(vc, animated: true)
    }
    
    
}
