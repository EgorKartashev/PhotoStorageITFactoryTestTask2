// сделать кэширование
// Mvvm

// ДОПОЛНИТЕЛЬНО
// добавить бесконечную прокуртку
// добавить избранное в детейл вью контроллер и табБар?
// добавить фильтрацию

import UIKit

class MainViewController: UIViewController {

    var collectionView: UICollectionView!
    var photos: [Photo] = []
       
       var viewModel: MainViewModel!

       override func viewDidLoad() {
           super.viewDidLoad()
           setupViewModel()
           setupCollectionView()
           viewModel.fetchPhotos()
           
           print(viewModel.photosCount, "didload")
           let delayInSeconds: Double = 1.0
           DispatchQueue.global().asyncAfter(deadline: .now() + delayInSeconds) {
               print(self.viewModel.photosCount,"Printed after 3 seconds")
           }
           
       }
       
       private func setupViewModel() {
           viewModel = MainViewModel()
           viewModel.updateUI = { [weak self] in
               DispatchQueue.main.async {
                   self?.collectionView.reloadData()
               }
           }
       }
       
       private func setupCollectionView() {
           let layout = UICollectionViewFlowLayout()
           layout.itemSize = CGSize(width: view.bounds.width - 80, height: 150)

           collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
           
           collectionView.dataSource = self
           collectionView.delegate = self
           collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: "PhotoCell")
           view.addSubview(collectionView)
       }
   }

   extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
       func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return viewModel.photosCount
       }
       
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCollectionViewCell else {return UICollectionViewCell()}
           cell.configure(photo: viewModel.photos[indexPath.row])
           print(photos.count, "\(indexPath.row)")
           return cell
       }
       
       // 1. ПЕРЕНЕСТИ ВО ВЬЮ МОДЕЛЬ?
       
       func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           let vc = PhotoDetailViewController()
           vc.viewModel = PhotoDetailViewModel(photo: viewModel.photos[indexPath.row])
           present(vc, animated: true)
           print("\(indexPath)")
       }
       

   }
