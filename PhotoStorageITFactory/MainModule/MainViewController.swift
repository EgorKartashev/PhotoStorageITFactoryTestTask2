
    // Доделать

    // Избранное
//сохранять айди измененого фото
// когда открываю экран мейнВс релоад дата, при этом написать функцию, которая из массива photo исверяет с массивом favoritePhotos и меняет значение id массиве, затем релоад дата, и еще при этом при построении коллекции, должна быть проверка на isFavorite

// ?сделать фото менеджер (модель)

// написать функцию загрузки фото по albumID в нетворк менеджере и loadMore
// сделать что бы перерисовывалась и коллекция на MainVC и соотвественно менялся массив photos  во вью модели
// переписать дидскролл в MainViewController

// Избранное сделать
// добавить фильтрацию
// добавить алерты при ошибке загрузки фото?
// убрать комменты, выровнять, запушить
// мейн ассембли для феворит фото

 //****************** ОШИБКИ **************

    // 1. Архитектура

// Не очень понравилась связь вьюмодели с моделью через клоужеры, при большом приложении это будет не удобно



//****************** ВОПРОСЫ **************
// протокол инпут аутпут что такое?
// почему при закрытии детейлВС картинка задерживается на экране как будто
// надо ли переносить пострение ячейки в Assembly?
// корректно ли вызывать конфигур ячейки как сделал я, возвращая ячейку как результат?
// правильно ли работает вью модель в детейл?

//****************** МОИ ИДЕИ **************


import UIKit
//MARK: - Private constants

private enum Size {
    static let cellWidth: CGFloat = UIScreen.main.bounds.width - 80
    static let cellHeight: CGFloat = 150
    static let cornerRadius: CGFloat = 10
    
    static let toFavoriteVcButtonLeadingConstraint: CGFloat = 100
    static let toFavoriteVcButtonTrailingConstraint: CGFloat = -100
    static let collectionViewTopConstraint: CGFloat = 40
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
        viewModel?.viewDidLoad()
        setupViews()
        setupDelegates()
        setupConstrants()
    }
    //  УБРАТЬ
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("WillApear")
    }
    
    //MARK: - Private Functions
    
    private func setupViewModel() {
        viewModel?.delegate = self
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
            toFavoriteVcButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Size.toFavoriteVcButtonLeadingConstraint),
            toFavoriteVcButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Size.toFavoriteVcButtonTrailingConstraint),
            
            collectionView.topAnchor.constraint(equalTo: toFavoriteVcButton.bottomAnchor,constant: Size.collectionViewTopConstraint),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func makeToFavoriteVcButton() -> UIButton {
        let button = UIButton()
        button.setTitle("Favorite", for: .normal)
        button.layer.cornerRadius = Size.cornerRadius
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
    print("КОЛИЧСТВО ФОТО", viewModel?.photos.count ?? 0)
      return viewModel?.photos.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.photoCellID, for: indexPath) as? PhotoCollectionViewCell else {return UICollectionViewCell()}
        guard let viewModel = viewModel else { return UICollectionViewCell() }
        cell.configure(photo: viewModel.photos[indexPath.row], viewModele: viewModel, cell: cell)
        return cell
    }
}

//MARK: - Delegate

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        coordinator.showPhotoDetail(photo: viewModel.photos[indexPath.row])
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let position = scrollView.contentOffset.y
//        let distanceToBottom = collectionView.contentSize.height - position - scrollView.frame.size.height
//        if let viewModel = viewModel{
//            if distanceToBottom < 100 && !viewModel.isLoadingData {
//                viewModel.fetchPhotos()
//            }
//        }
//    }
}

extension MainViewController: PhotoDetailViewModelDelegate {
    func photoDetailViewModelDidUpdateFavoriteState(viewModel: PhotoDetailViewModel, isFavorite: Bool) {
        collectionView.reloadData()
    }
}

extension MainViewController: MainViewRepresentableProtocol {
    func viewStateChanged(state: MainViewState) {
        switch state{
        case .loading:
            print("Loading")
        case .loaded(let photos):
            self.viewModel?.photos = photos
            collectionView.reloadData()
        case .error(let error):
            print(error)
        }
    }
    
    
}
