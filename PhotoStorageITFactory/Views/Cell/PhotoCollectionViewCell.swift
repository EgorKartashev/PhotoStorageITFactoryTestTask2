
import UIKit

//MARK: - Private constants

private enum Size {
    static let cornerRadius: CGFloat = 10
    static let borderWidth: CGFloat = 1
    static let labelLeadingConstraint: CGFloat = 16
    static let labelTrailingConstraint: CGFloat = -16
    static let numberOfLinesTitleLabel: Int = 0
    static let photoImageHeigthConstraint: CGFloat = 150
}

final class PhotoCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Private propertise
    
    lazy var photoImageView = makePhotoImage()
    lazy var titleLabel = makeTitleLabel()
    
    private var imageLoadingTask: URLSessionTask?
    
    static var photoCellID = "PhotoCell"
    
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
        
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.layer.cornerRadius = Size.cornerRadius
        contentView.layer.borderWidth = Size.borderWidth
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            photoImageView.widthAnchor.constraint(equalToConstant: Size.photoImageHeigthConstraint),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: Size.labelLeadingConstraint),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: Size.labelTrailingConstraint),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
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
        label.numberOfLines = Size.numberOfLinesTitleLabel
        return label
    }
    
    func configure(photo: Photo) {
        NetworkManager.shared.configureCell(cell: self, photo: photo)
    }
}
