
import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    var photoImageView = UIImageView()
    var titleLabel = UILabel()
    
    func  configure(photo: Photo){
        
      //  contentView.backgroundColor = .red
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.black.cgColor
        
        contentView.clipsToBounds = true
        
        photoImageView = UIImageView(frame: contentView.bounds)
        photoImageView.contentMode = .scaleAspectFit
        titleLabel.numberOfLines = 0
        contentView.addSubview(photoImageView)
        contentView.addSubview(titleLabel)
        
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            photoImageView.widthAnchor.constraint(equalToConstant: 150),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -16),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),   
            
        ])
        
        if let url = URL(string: photo.thumbnailUrl) {
            DispatchQueue.global().async {
                do {
                    let data = try Data(contentsOf: url)
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        self.photoImageView.image = image
                        self.titleLabel.text = photo.title
                    }
                } catch {
                    print ("Error loading image: \(error)")
                }
            }
        }
    }
    
}
