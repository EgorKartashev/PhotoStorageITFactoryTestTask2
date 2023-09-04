
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
        let mainViewController = MainAssembly.createMainViewController(with: self)
        navigationController.pushViewController(mainViewController, animated: false)
    }

    func showPhotoDetail(photo: Photo) {
        let detailViewController = MainAssembly.createPhotoDetailController(with: self,photo: photo)
        navigationController.pushViewController(detailViewController, animated: true)
    }
    
    func showFavoriteViewController(photos: [Photo]) {
        let favoriteViewController = MainAssembly.createFavoriteViewController(with: self, photos: photos)
        navigationController.pushViewController(favoriteViewController, animated: true)
    }
}
