
import Foundation
import UIKit

enum MainViewState {
    case loaded([Photo])
    case error(String)
    case sorted([Photo])
}

protocol MainViewRepresentableProtocol: AnyObject {
    func viewStateChanged(state: MainViewState)
}

protocol MainViewModelProtocol {
    var delegate: MainViewRepresentableProtocol? { get set }
    var photos: [Photo] { get set}
    var isLoading: Bool { get set}
    func viewDidLoad()
    func loadMorePhotos()
    func cellConfigure(photo: Photo, cell: PhotoCollectionViewCell) -> Void
    func viewWillAppear()
    func sortedByFavoriteButtonPressed()
}

final class MainViewModel: MainViewModelProtocol {
    
    weak var delegate: MainViewRepresentableProtocol?
    
    var photos: [Photo] = []
    var albumID = 1
    var isLoading = false
    
    func photoTitle(at index: Int) -> String {
        photos[index].title
    }
    
    func viewDidLoad(){
        UserDefaults.standard.removeObject(forKey: Resources.KeyUserDefaults.favoritePhotoIDs)
        fetchPhotos()
    }
    
    func loadMorePhotos(){
        fetchPhotos()
    }
    
    func viewWillAppear(){
        let favoritePhotos = UserDefaults.standard.stringArray(forKey: Resources.KeyUserDefaults.favoritePhotoIDs) ?? []
        toggleFavoriteStatus(photos: &photos, idsToToggle: favoritePhotos)
    }
    
    func sortedByFavoriteButtonPressed() {
        let sortedPhoto = photos.sorted {$0.isFavorite && !$1.isFavorite}
        delegate?.viewStateChanged(state: .sorted(sortedPhoto))
    }
    
    func fetchPhotos() {
        isLoading = true
        NetworkManager.shared.fetchPhotos(albumID: self.albumID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case.success(let photos):
                self.photos.append(contentsOf: photos)
                self.delegate?.viewStateChanged(state: .loaded(self.photos))
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.isLoading = false
                }
                self.albumID += 1
            case.failure(let error):
                self.delegate?.viewStateChanged(state: .error(error.localizedDescription))
            }
        }
    }
    
    func cellConfigure(photo: Photo, cell: PhotoCollectionViewCell) -> Void {
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
                    print("Alert ошибка получения данных", error.localizedDescription)
                }
            }
        }
    }
    
    func toggleFavoriteStatus(photos: inout [Photo], idsToToggle: [String]) {
        for index in photos.indices {
            let photoIdString = String(photos[index].id)
            if idsToToggle.contains(photoIdString) {
                photos[index].isFavorite = true
            } else {
                photos[index].isFavorite = false
            }
        }
    }
}

