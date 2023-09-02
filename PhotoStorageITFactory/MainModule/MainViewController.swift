
    // Доделать

// вынести все логику и константы из NetworkManager во вью модель

// Избранное сделать
// добавить фильтрацию
// добавить алерты при ошибке загрузки фото?
// убрать комменты, выровнять, запушить

 //****************** ОШИБКИ **************

    // 1. Архитектура

// Например MainViewControoler в viewdidload вызывается метод вьюмодели по загрузке элементов с сети, это должна делать сама вью модель, вью ничего не должно знать о логике.
// Так же в PhotoCollectionViewCell идет конфигурация вообще через сервис работы с сетью, этот сервис вообще о вью знать не должен.
// Так же сервис по работе с сетью хранит в себе айдишники альбомов, тоесть тоже информацию которую знать не должен, это должно быть в модели.
// Создал MainAssembly для конфигурации модуля главного экрана но не использовал его и для других экранов не стал такое делать.
// Не очень понравилась связь вьюмодели с моделью через клоужеры, при большом приложении это будет не удобно


    // 2. Работа с сетью

// Тут все грустно, все сделано в лоб без ассинхрлонности и соответсвенно все ужасно глючит при работе приложения. Каждый раз при подгрузке пр скроллинге скачиваются все 5000 фоток и просто фильтрует часть. В общем очень плохо
// Ошибки не выводятся пользователю и никак не обрабатываются

//****************** ВОПРОСЫ **************





//****************** МОИ ИДЕИ **************

// изменить все ниже на ID вместо Photo
// написать user defaults который грузит множество <Set> Photo
// функция в MemoryManagere? (МайнВьюМодели) которая сохраняет массив Photo в userDeafaults и выгружает его оттуда
// функция которая принимает photo как параметр, выгружает массив Photo  и меняет значение isFavorite  у этого фото по id и загружает обратно в UserDefaults
// 2 функции с параметрами Photo, одна выгружает массив favoritePgotos из UserDefaults записывает туда фото и загружает обратно, другая то же самое только удаляет по id

// не обновляется главная коллекция после DetailVIewController
// почему после юзерДефолтс массив фейворитФото пусто, проверить что выгружается из Юзер дефолтс
// вынести все константы в R  или Constants



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
        // вьюшка должна говорить вьмодели что она загрузилась как это сделаьть?
        // протокол инпут аутпут что такое?
        // вью модель должна знать в каком она состоянии лоадинг, фетч и тд,
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
