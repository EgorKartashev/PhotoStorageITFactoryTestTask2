
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
        let mainViewController = MainViewController(coordinator: self)
        navigationController.pushViewController(mainViewController, animated: false)
    }

    func showPhotoDetail(photo: Photo) {
        let photoDetailViewModel = PhotoDetailViewModel(photo: photo)
        let photoDetailViewController = PhotoDetailViewController(viewModel: photoDetailViewModel)
        navigationController.pushViewController(photoDetailViewController, animated: true)
    }
}
