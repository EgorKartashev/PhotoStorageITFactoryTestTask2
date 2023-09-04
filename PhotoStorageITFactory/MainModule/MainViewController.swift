
//****************** ДОДЕЛАТЬ **************


// добавить сортировку по ID  или isFavorite или по title

// добавить фильтрацию?
// добавить алерты при ошибке загрузки фото?
// убрать комменты, выровнять, поправить Марки, запушить
// удалить фейворитВьюМодель?

    // ДОП ДОПЫ
// спиннер на ячейке пока грузится фото
// спустить кнопки вниз
// ?сделать фото менеджер (модель)
// изменить фейворитВС что бы открывался детейлВС?
// избранное не сохраняется после перезапуска, только если докуртить до нужного места ( надо добавить проверку на избранное при первом звпуске)  (или при загрузке в фетчФото надо вызвать функцию проверки массива соответсвено массиу сохраненых айдишников в userDeafaults а потом строить коллекцию или reloadData()

//****************** ВОПРОСЫ **************
// путаюсь в инициализаторе вьюмодели почем там протокол, потом в ассембли инфиализируем...рзобраться
// правильный ли подход релоад дата во viewWillAppear делать?
// протокол инпут аутпут что такое?
// надо ли переносить пострение ячейки в Assembly?
// корректно ли вызывать конфигур ячейки как сделал я, возвращая ячейку как результат?
// правильно ли работает вью модель в детейл?


import UIKit
//MARK: - Private constants

private enum Size {
    static let cellWidth: CGFloat = UIScreen.main.bounds.width - 80
    static let cellHeight: CGFloat = 150
    static let cornerRadius: CGFloat = 10
    
    static let toFavoriteVcButtonLeadingConstraint: CGFloat = 100
    static let toFavoriteVcButtonTrailingConstraint: CGFloat = -100
    
    static let sortedFavoriteButtonTopConstraint: CGFloat = 16
    static let sortedFavoriteButtonLeadingConstraint: CGFloat = 100
    static let sortedFavoriteButtonTrailingConstraint: CGFloat = -100

    
    static let collectionViewTopConstraint: CGFloat = 16
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
    private lazy var sortedFavoriteButton: UIButton = makeSortedFavoriteButton()
    
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
        super.viewDidLoad()
        // УБРАТЬ ПОТОМ
        UserDefaults.standard.removeObject(forKey: Resources.KeyUserDefaults.favoritePhotoIDs)
        setupViewModel()
        viewModel?.viewDidLoad()
        setupViews()
        setupDelegates()
        setupConstrants()
    }
    //  норм тут делать релоад?
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        print("WillApear")
//        print("**************************** DO *************")
//        print(viewModel?.photos)
        viewModel?.viewWillAppear()
//        print("**************************** POSLE *************")
//        print(viewModel?.photos)
        collectionView.reloadData()
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
        view.addSubview(sortedFavoriteButton)
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
            
            collectionView.topAnchor.constraint(equalTo: sortedFavoriteButton.bottomAnchor,constant: Size.collectionViewTopConstraint),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            sortedFavoriteButton.topAnchor.constraint(equalTo: toFavoriteVcButton.bottomAnchor, constant: Size.sortedFavoriteButtonTopConstraint),
            sortedFavoriteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Size.sortedFavoriteButtonLeadingConstraint),
            sortedFavoriteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Size.sortedFavoriteButtonTrailingConstraint),
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
    
    func makeSortedFavoriteButton() -> UIButton {
        let button = UIButton()
        button.setTitle("Sorted by isFavorite", for: .normal)
        button.layer.cornerRadius = Size.cornerRadius
        button.backgroundColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(sortedByFavorite), for: .touchUpInside)
        return button
    }
    
    
    // перенести во вью модель?
    @objc private func toFavoriteVC() {
     //   viewModel?.toFavoriteVC()
        coordinator.showFavoriteViewController(photos: viewModel?.photos ?? [])
    }
    
    @objc private func sortedByFavorite() {
        viewModel?.sortedByFavoriteButtonPressed()
    }
}

//MARK: - Data Source

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
  //  print("КОЛИЧСТВО ФОТО", viewModel?.photos.count ?? 0)
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let distanceToBottom = collectionView.contentSize.height - position - scrollView.frame.size.height
        if let viewModel = viewModel{
            if distanceToBottom < 100 && !viewModel.isLoading {
                // переименовать функцию во вью модели???
                viewModel.viewDidLoad()
            }
        }
    }
}

//extension MainViewController: PhotoDetailViewModelDelegate {
//    func photoDetailViewModelDidUpdateFavoriteState(viewModel: PhotoDetailViewModel, isFavorite: Bool) {
//        collectionView.reloadData()
//    }
//}

extension MainViewController: MainViewRepresentableProtocol {
    func viewStateChanged(state: MainViewState) {
        switch state{
        case .loading:
            // Delete
            print("Loading")
        case .loaded(let photos):
            self.viewModel?.photos = photos
            collectionView.reloadData()
        case .error(let error):
            print(error)
        }
    }
    
    
}
