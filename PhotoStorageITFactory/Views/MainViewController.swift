        // ДОПОЛНИТЕЛЬНО
// добавить бесконечную прокуртку
// добавить избранное в детейл вью контроллер и табБар?
// добавить фильтрацию

        // Спросить на созвоне
// как перенести переход во вью модель?
// изменить код стиль в networkManager  заменить ифлет на гуард и убрать комплишен нил,
// вьюМодели подписать под протооколы?
// нужна ли вью модель для каждого контроллера и ячейки?

// Dipendency Injection для этого ассембли?, Dependency inversion для этого протоколы для вью моделей?
// сделать ассембли отдельно и добавить туда объявление вьюмоделей, всех или только одной?
// как сделать пангинацию?
// makeUIimage -> это фабричные методы? паттер фабрика


import UIKit


//MARK: - Private constants

private enum Size{
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
    
    private var photos: [Photo] = []
    private var viewModel: MainViewModel?
    
    //MARK: - Lifecycles aunctions
    
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

//MARK: - Extensions

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.photosCount ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.photoCellID, for: indexPath) as? PhotoCollectionViewCell else {return UICollectionViewCell()}
        guard let viewModel else { return UICollectionViewCell() }
        cell.configure(photo: viewModel.photos[indexPath.row])
        return cell
    }
}
// 1. ПЕРЕНЕСТИ ВО ВЬЮ МОДЕЛЬ?
extension MainViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = PhotoDetailViewController()
        guard let viewModel else { return }
        vc.viewModel = PhotoDetailViewModel(photo: viewModel.photos[indexPath.row])
        self.present(vc, animated: true)
//        viewModel?.showPhotoDetail(at: indexPath)
    }
}
