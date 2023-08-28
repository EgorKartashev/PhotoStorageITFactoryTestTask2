// Доделать
// не передается массив фейворитФотос
// вынести все константы в R  или Constants

// ДОПЫ
// добавить фильтрацию
// добавить пролистывание коллекции детейлВС
// добавить спинер на главный экран загрузку и в детейл

import UIKit
//MARK: - Private constants

private enum Size {
    static let cellWidth: CGFloat = UIScreen.main.bounds.width - 80
    static let cellHeight: CGFloat = 150
}

final class MainViewController: UIViewController {
    
    //MARK: - Private propertise
    
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: Size.cellWidth, height: Size.cellHeight)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.photoCellID)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var toFavoriteVcButton: UIButton = makeToFavoriteVcButton()
    
    private var viewModel: MainViewModelProtocol?
    private let coordinator: MainCoordinator
    
    //MARK: - Lifecycles aunctions
    
    init(
        viewModel: MainViewModelProtocol,
        coordinator: MainCoordinator
    ) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        // УБРАТЬ ПОТОМ
        UserDefaults.standard.removeObject(forKey: "favoritePhotoIDs")
        
        super.viewDidLoad()
        setupViewModel()
        viewModel?.fetchPhotos()
        setupViews()
        setupDelegates()
        setupConstrants()
    }
    //  УБРАТЬ
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("WillApear")
        let favoritePhotoIDs = UserDefaults.standard.stringArray(forKey: "favoritePhotoIDs") ?? []
        print(favoritePhotoIDs.count)
    }
    
    //MARK: - Private Functions
    
    private func setupViewModel() {
        viewModel?.updateUI = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    //MARK: - UI
    
    private func setupViews(){
        view.backgroundColor = .white
        view.addSubview(collectionView)
        view.addSubview(toFavoriteVcButton)
    }
    
    private func setupDelegates(){
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func setupConstrants(){
        NSLayoutConstraint.activate([
            toFavoriteVcButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            toFavoriteVcButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
            toFavoriteVcButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
            
            collectionView.topAnchor.constraint(equalTo: toFavoriteVcButton.bottomAnchor,constant: 40),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func makeToFavoriteVcButton() -> UIButton {
        let button = UIButton()
        button.setTitle("Favorite", for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(toFavoriteVC), for: .touchUpInside)
        return button
    }
    
    @objc private func toFavoriteVC() {
        coordinator.showFavoriteViewController()
    }
}

//MARK: - Data Source

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.photos.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.photoCellID, for: indexPath) as? PhotoCollectionViewCell else {return UICollectionViewCell()}
        guard let viewModel = viewModel else { return UICollectionViewCell() }
        cell.configure(photo: viewModel.photos[indexPath.row])
        return cell
    }
}

//MARK: - Delegate

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        coordinator.showPhotoDetail(photo: viewModel.photos[indexPath.row])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let distanceToBottom = collectionView.contentSize.height - position - scrollView.frame.size.height
        if let viewModel = viewModel{
            if distanceToBottom < 100 && !viewModel.isLoadingData {
                viewModel.fetchPhotos()
            }
        }
    }
}

extension MainViewController: PhotoDetailViewModelDelegate {
    func photoDetailViewModelDidUpdateFavoriteState(viewModel: PhotoDetailViewModel) {
        collectionView.reloadData()
    }
}
