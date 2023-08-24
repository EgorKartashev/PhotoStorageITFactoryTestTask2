
import UIKit

class PhotoDetailViewController: UIViewController {
    var imageView: UIImageView!
    
    var viewModel: PhotoDetailViewModel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.loadImage { [weak self] image in
            DispatchQueue.main.async {
                self?.imageView.image = image
//                self?.imageView.heightAnchor.constraint(equalToConstant: image?.size.height ?? 0).isActive = true
            }
        }
        setupImageView()
        view.backgroundColor = .black
    }
    
    private func setupImageView() {
        imageView = UIImageView()
        //imageView.backgroundColor = .red
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            imageView.heightAnchor.constraint(equalToConstant: 400)
        ])
    }
}
