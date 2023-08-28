
import UIKit

private enum ConstantFavVC {
    static let imageViewTopConstraint: CGFloat = 40
    static let imageViewLeadingConstraint: CGFloat = 40
    static let imageViewTrailingConstraint: CGFloat = -40
    static let imageViewBottomConstraint: CGFloat = -40
    static let favoritePhotoSystemImage: String = "star.fill"
    static let unFavoritePhotoSystemImage: String = "star"
    static let unfavoriteButtonTitle: String = "Add to Favorite Photos"
    static let favoriteButtonTitle: String = "Remove at Favorite Photos"
}

final class PhotoDetailViewController: UIViewController {
    
    private lazy var imageView = makeImageView()
    private lazy var starImageView = makeStarImage()
    private lazy var favoriteButton = makeFavoriteButton()
    
    var viewModel: PhotoDetailViewModel?
    // убрать отсюда
    var viewModelF: FavoritePhotoViewModele?
    
    init(viewModel: PhotoDetailViewModel, viewModelF: FavoritePhotoViewModele) {
        self.viewModel = viewModel
        self.viewModelF = viewModelF
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupImage()
    }
    
    private func setupImage(){
        viewModel?.loadImage { [weak self] image in
            DispatchQueue.main.async {
                self?.imageView.image = image
            }
        }
    }
    
    func makeImageView() -> UIImageView{
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }
    
    func makeStarImage() -> UIImageView{
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: ConstantFavVC.unFavoritePhotoSystemImage)
        return imageView
    }
    
    func makeFavoriteButton() -> UIButton {
        let button = UIButton()
        if let viewModel = viewModel{
            if !viewModel.photo.isFavorite {
                button.setTitle(ConstantFavVC.unfavoriteButtonTitle, for: .normal)
            } else {
                button.setTitle(ConstantFavVC.favoriteButtonTitle, for: .normal)
            }
        }
        button.setTitleColor(.blue, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.blue.cgColor
        // изменить 
        if let viewModel = viewModel {
            let photo = viewModel.photo
            button.addTarget(self, action: #selector(favoriteButtonPressed), for: .touchUpInside)
        }
        return button
    }
  
    @objc func favoriteButtonPressed() {
        if let viewModel = viewModel, let viewModelF = viewModelF {
            if !viewModel.photo.isFavorite{
                favoriteButton.setTitle(ConstantFavVC.favoriteButtonTitle, for: .normal)
                viewModel.photo.isFavorite.toggle()
                starImageView.image = UIImage(systemName: ConstantFavVC.favoritePhotoSystemImage)
               // let viewModeleF = FavoritePhotoViewModele(photo: viewModel.photo)
                viewModelF.addToFavotirePhotos(photo: viewModel.photo)
                print(viewModelF.favoritePhotos.count)
            } else {
                favoriteButton.setTitle(ConstantFavVC.unfavoriteButtonTitle, for: .normal)
                viewModel.photo.isFavorite.toggle()
                starImageView.image = UIImage(systemName: ConstantFavVC.unFavoritePhotoSystemImage)
                viewModelF.removeFromFavoritePhotos(photo: viewModel.photo)
                print(viewModelF.favoritePhotos.count)
            }
        }
    }
    
    private func setupUI(){
        view.backgroundColor = .white
        
        view.addSubview(imageView)
        view.addSubview(favoriteButton)
        view.addSubview(starImageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        starImageView.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        
        // ВЫНЕСТИ ВСЕ В КОНСТАНТЫ
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:  16),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            favoriteButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            favoriteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            favoriteButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -16),
            
            starImageView.topAnchor.constraint(equalTo: favoriteButton.topAnchor,constant: 6),
            starImageView.trailingAnchor.constraint(equalTo: favoriteButton.trailingAnchor, constant: -16),
            starImageView.bottomAnchor.constraint(equalTo: favoriteButton.bottomAnchor, constant: -6),
        ])
    }
}
