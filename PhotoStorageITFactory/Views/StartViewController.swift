
import UIKit

class StartViewController: UIViewController {
    var button = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let vm = MainViewModel()
       // vm.fetchPhotos()
        view.backgroundColor = .blue
        button.setTitle("PhotoStorage", for: .normal)
        view.addSubview(button)
        button.addTarget(self, action: #selector(toPhotoStorage), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 200),
            button.heightAnchor.constraint(equalToConstant: 100)
            
        ])
    }
    
    @objc func toPhotoStorage(){
        let vc = MainViewController()
        present(vc, animated: true)
        vc.modalPresentationStyle = .fullScreen
    }
    


}
