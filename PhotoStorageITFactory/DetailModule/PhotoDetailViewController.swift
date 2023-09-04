
import UIKit

private enum Size {
    static let imageViewTopConstraint: CGFloat = 100
    static let imageViewLeadingConstraint: CGFloat = 16
    static let imageViewTrailingConstraint: CGFloat = -16
    static let favoriteButtonTopConstraint: CGFloat = 16
    static let favoriteButtonLeadingConstraint: CGFloat = 16
    static let favoriteButtonTrailingConstraint: CGFloat = -16
    static let starImageViewTopConstraint: CGFloat = 6
    static let starImageViewTrailingConstraint: CGFloat = -16
    static let starImageViewBottomConstraint: CGFloat = -6
    
    static let cornerRadius: CGFloat = 10
    static let widthBorder: CGFloat = 1
    
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
    
    init(viewModel: PhotoDetailViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.delegate = self
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
        imageView.contentMode = .scaleAspectFit
        return imageView
    }
    
    func makeStarImage() -> UIImageView{
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: Size.unFavoritePhotoSystemImage)
        return imageView
    }
    
    func makeFavoriteButton() -> UIButton {
        let button = UIButton()
        if let viewModel = viewModel{
            if !viewModel.photo.isFavorite {
                button.setTitle(Size.unfavoriteButtonTitle, for: .normal)
                starImageView.image = UIImage(systemName: Size.unFavoritePhotoSystemImage)
            } else {
                button.setTitle(Size.favoriteButtonTitle, for: .normal)
                starImageView.image = UIImage(systemName: Size.favoritePhotoSystemImage)
            }
        }
        button.setTitleColor(.blue, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = Size.cornerRadius
        button.layer.borderWidth = Size.widthBorder
        button.layer.borderColor = UIColor.blue.cgColor
        button.addTarget(self, action: #selector(favoriteButtonPressed), for: .touchUpInside)
        return button
    }
    
    @objc func favoriteButtonPressed() {
        viewModel?.favoriteButtonPressed()
    }
    
    private func setupUI(){
        view.backgroundColor = .white
        
        view.addSubview(imageView)
        view.addSubview(favoriteButton)
        view.addSubview(starImageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        starImageView.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: Size.imageViewTopConstraint),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:  Size.imageViewLeadingConstraint),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Size.imageViewTrailingConstraint),
            
            favoriteButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: Size.favoriteButtonTopConstraint),
            favoriteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Size.favoriteButtonLeadingConstraint),
            favoriteButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: Size.favoriteButtonTrailingConstraint),
            
            starImageView.topAnchor.constraint(equalTo: favoriteButton.topAnchor,constant: Size.starImageViewTopConstraint),
            starImageView.trailingAnchor.constraint(equalTo: favoriteButton.trailingAnchor, constant: Size.starImageViewTrailingConstraint),
            starImageView.bottomAnchor.constraint(equalTo: favoriteButton.bottomAnchor, constant: Size.starImageViewBottomConstraint),
        ])
    }
}

extension PhotoDetailViewController: PhotoDetailViewModelDelegate{
    func photoDetailViewModelDidUpdateFavoriteState(viewModel: PhotoDetailViewModel, isFavorite: Bool) {
        favoriteButton.setTitle(isFavorite ? Size.favoriteButtonTitle : Size.unfavoriteButtonTitle, for: .normal)
        starImageView.image = UIImage(systemName: isFavorite ? Resources.SystemImages.favorirephotoSystemImage : Resources.SystemImages.unFavorirephotoSystemImage)
    }
}
