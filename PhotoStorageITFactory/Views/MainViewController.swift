         // Доделать
// добавить избранное в детейл вью контроллер и табБар?
    // при добавление в массив избранное значение не сохраняется ( и еще надо сделать обновление основного массива и обновление колекшен вью)
    // точенн сохраняется пока не уходить с детейлВС, плюсуется но не удаляется
    // при добавление фото в массив наддо проверить на наличие в массиве?
    // сделать феворитВС
    // добавить таб бар с двумя контроллерами




// сделать ассембли
// протокол для мейн и фейворит вью моделей
// проверка загрузки фото, дефолтное фото, обработка ошибок
// переделать NetworkManager  на Result<Photo, Error >
// добавить ReadMe на GitHub
// перенести все во вьюмодели, убрать комменты и пробелы, выровнят код
// вынести все константы в R  или Constants
// перенести во вью модель все из фотоДетейлВС
// убрать вьюмоедли в ассембли


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

protocol MainViewModelProtocol {
    var photos: [Photo] { get }
    var isLoadingData: Bool { get }
    var updateUI: (() -> Void)? { get set }
    func fetchPhotos()
    
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
    
    private var viewModel: MainViewModel?
    private let coordinator: MainCoordinator
    
    //MARK: - Lifecycles aunctions
    
    init(coordinator: MainCoordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        viewModel?.fetchPhotos()
        setupViews()
        setupDelegates()
        setupConstrants()
    }
    
    //MARK: - Private Functions
    
    private func setupViewModel() {
        viewModel = MainViewModel()
        viewModel?.updateUI = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    //MARK: - UI
    
    private func setupViews(){
        view.addSubview(collectionView)
    }
    
    private func setupDelegates(){
        collectionView.delegate = self
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

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.photos.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.photoCellID, for: indexPath) as? PhotoCollectionViewCell else {return UICollectionViewCell()}
        guard let viewModel else { return UICollectionViewCell() }
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
