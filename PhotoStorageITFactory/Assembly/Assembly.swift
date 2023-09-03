
import Foundation

class MainAssembly {
    static func createMainViewController(with coordinator: MainCoordinator) -> MainViewController {
        let mainViewModel = MainViewModel()
        
        let viewController = MainViewController(
            viewModel: mainViewModel,
            coordinator: coordinator
        )
        return viewController
    }
    static func createPhotoDetailController(with coordinator: MainCoordinator,photo: Photo) -> PhotoDetailViewController {
        let photoDetailViewModele = PhotoDetailViewModel(photo: photo)
        
        let detailViewController = PhotoDetailViewController(viewModel: photoDetailViewModele)
        return detailViewController
    }
}






