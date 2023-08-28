
import Foundation
import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}

class MainCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = MainViewModel()
        let mainViewController = MainViewController(viewModel: viewModel, coordinator: self)
        navigationController.pushViewController(mainViewController, animated: false)
    }

    func showPhotoDetail(photo: Photo) {
        let viewModele = MainViewModel()
        let photoDetailViewModel = PhotoDetailViewModel(photo: photo)
        let favoritePhotoViewModele = FavoritePhotoViewModel(mainViewModel: viewModele)
        let photoDetailViewController = PhotoDetailViewController(viewModel: photoDetailViewModel, viewModelF: favoritePhotoViewModele)
        navigationController.pushViewController(photoDetailViewController, animated: true)
    }
    
    func showFavoriteViewController() {
        let favoriteViewController = FavoritePhotoViewController(coordinator: self)
        navigationController.pushViewController(favoriteViewController, animated: true)
    }
}
