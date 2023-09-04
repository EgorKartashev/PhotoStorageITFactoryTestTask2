
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
   // var favoritePhotos: [Photo] = []
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // не Корректно здесь это делать?
        viewModel?.favoritePhotos.removeAll {$0.isFavorite == false}
        collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.viewDidLoad()
        setupViews()
        setupDelegates()
        setupConstrants()
    }
    
    //MARK: - Private Functions
    
//    private func setupViewModel() {
//        let mainViewModele = MainViewModel()
//        viewModel = FavoritePhotoViewModel(mainViewModel: mainViewModele)
//        viewModel?.updateUI = { [weak self] in
//            DispatchQueue.main.async {
//                self?.collectionView.reloadData()
//            }
//        }
//    }
    //MARK: - UI
    
    private func setupViews(){
        view.addSubview(collectionView)
    }
    
    private func setupDelegates(){
//        collectionView.delegate = self
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

//MARK: - Delegate

// ИСПРАВИТЬ ИЛИ УДАЛИТЬ, когда из фейвоиитВС я открываю детейлВС, удаляю объект, не обновляется коллекция favoriteVC и массив фейворитФотос (так же УДАЛИТЬ лишнее в модели и ячейки

//extension FavoritePhotoViewController: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        guard let viewModel = viewModel else { return }
//        coordinator.showPhotoDetail(photo: viewModel.favoritePhotos[indexPath.row])
//    }
//}
