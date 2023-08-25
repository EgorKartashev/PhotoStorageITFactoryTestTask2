
import UIKit

private enum Size{
    static let imageViewTopConstraint: CGFloat = 40
    static let imageViewLeadingConstraint: CGFloat = 40
    static let imageViewTrailingConstraint: CGFloat = -40
    static let imageViewBottomConstraint: CGFloat = -40
}

final class PhotoDetailViewController: UIViewController {
    
    private lazy var imageView = makeImageView()
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
    
    private func setupUI(){
        view.backgroundColor = .black
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: Size.imageViewTopConstraint),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Size.imageViewLeadingConstraint),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Size.imageViewTrailingConstraint),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: Size.imageViewBottomConstraint)
        ])
    }
}
