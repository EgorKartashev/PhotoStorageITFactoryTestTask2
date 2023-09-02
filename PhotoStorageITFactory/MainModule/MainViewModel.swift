
import Foundation
import UIKit

protocol MainViewModelProtocol {
    var photos: [Photo] { get }
    var isLoadingData: Bool { get }
    var updateUI: (() -> Void)? { get set }
    func fetchPhotos()
}

final class MainViewModel: MainViewModelProtocol {
    
    var photos: [Photo] = []
    var favoritePhotos: [Photo] = []
    var updateUI: (() -> Void)?
    var isLoadingData = false
    
    func photoTitle(at index: Int) -> String {
        photos[index].title
    }
    
    func fetchPhotos() {
        isLoadingData.toggle()
        
        NetworkManager.shared.fetchPhotos(albumID: NetworkManager.shared.albumId) { [weak self] result in
            switch result {
            case.success(let photos):
                self?.photos.append(contentsOf: photos)
                self?.updateUI?()
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.isLoadingData.toggle()
        }
    }
}

