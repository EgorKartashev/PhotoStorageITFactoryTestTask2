
import UIKit
//MARK: - Private constants

private enum Size {
    static let cellWidth: CGFloat = UIScreen.main.bounds.width - 80
    static let cellHeight: CGFloat = 150
}

final class FavoritePhotoViewController: UIViewController {
    
    //MARK: - Private propertise
    
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: Size.cellWidth, height: Size.cellHeight)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(FavoritePhotoCollectionViewCell.self, forCellWithReuseIdentifier: FavoritePhotoCollectionViewCell.cellId)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private var viewModel: FavoritePhotoViewModelProtocol?
    private let coordinator: MainCoordinator
    
    //MARK: - Lifecycles aunctions
    
    init(
        coordinator: MainCoordinator,
        viewModel: FavoritePhotoViewModelProtocol
    ) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupDelegates()
        setupConstrants()
    }
    
    //MARK: - UI
    
    private func setupViews(){
        view.addSubview(collectionView)
    }
    
    private func setupDelegates(){
        collectionView.dataSource = self
    }
    
    private func setupConstrants(){
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

//MARK: - Data Source

extension FavoritePhotoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.favoritePhotos.count ?? 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoritePhotoCollectionViewCell.cellId, for: indexPath) as? FavoritePhotoCollectionViewCell else {return UICollectionViewCell()}
        guard let viewModel else { return UICollectionViewCell() }
        cell.configure(photo: viewModel.favoritePhotos[indexPath.row])
        return cell
    }
}
