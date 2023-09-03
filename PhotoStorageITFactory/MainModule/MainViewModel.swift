
import Foundation
import UIKit

enum MainViewState {
    case loading
    case loaded([Photo])
    case error(String)
}

protocol MainViewRepresentableProtocol: AnyObject {
    func viewStateChanged(state: MainViewState)
}

protocol MainViewModelProtocol {
    var delegate: MainViewRepresentableProtocol? { get set }
    var photos: [Photo] { get set}
    func viewDidLoad()
    func cellConfigure(photo: Photo, cell: PhotoCollectionViewCell) -> Void
}

final class MainViewModel: MainViewModelProtocol {
    
    weak var delegate: MainViewRepresentableProtocol?
    
    var photos: [Photo] = []
    var albumID = 1
    var favoritePhotos: [Photo] = []
    
    func photoTitle(at index: Int) -> String {
        photos[index].title
    }
    
    func viewDidLoad(){
        fetchPhotos()
    }
    
    func fetchPhotos() {
        delegate?.viewStateChanged(state: .loading)
        NetworkManager.shared.fetchPhotos(albumID: self.albumID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case.success(let photos):
                self.photos.append(contentsOf: photos)
                self.delegate?.viewStateChanged(state: .loaded(photos))
                self.albumID += 1
            case.failure(let error):
                self.delegate?.viewStateChanged(state: .error(error.localizedDescription))
            }
        }
    }
    
    func cellConfigure(photo: Photo, cell: PhotoCollectionViewCell) -> Void {
       // let cell = PhotoCollectionViewCell()
        if !photo.isFavorite{
            cell.starImageView.image = UIImage(systemName: Resources.SystemImages.unFavorirephotoSystemImage)
        } else {
            cell.starImageView.image = UIImage(systemName: Resources.SystemImages.favorirephotoSystemImage)
        }
        if let cachedImage = ImageCache.shared.getImage(forKey: photo.thumbnailUrl) {
            DispatchQueue.main.async {
                cell.photoImageView.image = cachedImage
                cell.titleLabel.text = photo.title
            }
        } else {
            NetworkManager.shared.loadImage(photo: photo) { result in
                switch result {
                case .success(let image):
                    ImageCache.shared.setImage(image, forKey: photo.thumbnailUrl)
                    DispatchQueue.main.async {
                        cell.photoImageView.image = image
                        cell.titleLabel.text = photo.title
                    }
                case .failure(let error):
                    // СДЕЛАТЬ АЛЕРТ?
                    print("Alert ошибка получения данных", error.localizedDescription)
                }
            }
        }
       // return cell
    }
}

