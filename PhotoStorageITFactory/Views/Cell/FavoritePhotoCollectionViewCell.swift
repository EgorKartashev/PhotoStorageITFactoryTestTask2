
import UIKit

class FavoritePhotoCollectionViewCell: UICollectionViewCell {
    
    static let cellId = "FavoritePhotoCollectionViewCell"
    
    
    //MARK: - Private constants
    
    private enum Constants {
        static let cornerRadius: CGFloat = 10
        static let borderWidth: CGFloat = 1
        static let labelLeadingConstraint: CGFloat = 16
        static let labelTrailingConstraint: CGFloat = -16
        static let numberOfLinesTitleLabel: Int = 0
        static let photoImageHeigthConstraint: CGFloat = 150
    }
    
    
    //MARK: - Private propertise
    
    lazy var photoImageView = makePhotoImage()
    lazy var starImageView = makeStarImage()
    lazy var titleLabel = makeTitleLabel()
    
    private var imageLoadingTask: URLSessionTask?
    
    
    //MARK: - Lifecycles functions
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageLoadingTask?.cancel()
        photoImageView.image = nil
        titleLabel.text = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    //MARK: - UI
    
    private func setupUI() {
        
        contentView.addSubview(photoImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(starImageView)
        
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        starImageView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.layer.cornerRadius = Constants.cornerRadius
        contentView.layer.borderWidth = Constants.borderWidth
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            photoImageView.widthAnchor.constraint(equalToConstant: Constants.photoImageHeigthConstraint),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: Constants.labelLeadingConstraint),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: Constants.labelTrailingConstraint),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            starImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            starImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
        ])
    }
    
    //MARK: - Other Functions
    
    func makePhotoImage() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }
    
    func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = Constants.numberOfLinesTitleLabel
        return label
    }
    
    func makeStarImage() -> UIImageView{
        let imageView = UIImageView()
        return imageView
    }
    
    func configure(photo: Photo) {
        NetworkManager.shared.configureCell(cell: self, photo: photo)
    }
}


