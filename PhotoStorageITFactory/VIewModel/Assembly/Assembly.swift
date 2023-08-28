
import Foundation

class MainAssembly {
    static func createModule(with coordinator: MainCoordinator) -> MainViewController {
        let mainViewModel = MainViewModel()
        
        let viewController = MainViewController(
            viewModel: mainViewModel,
            coordinator: coordinator
        )
        return viewController
    }
}






