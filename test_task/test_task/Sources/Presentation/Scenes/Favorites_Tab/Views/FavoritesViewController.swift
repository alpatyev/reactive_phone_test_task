import UIKit

// MARK: - Favorites tab output protocol

protocol FavoritesTabOutput: AnyObject {}

// MARK: - Favorites tab ViewController

final class FavoritesTabViewController: UIViewController {
    
    // MARK: - UI
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
    }
    
    // MARK: - Setups
    
    private func setupView() {
        
    }
    
    private func setupHierarachy() {
        
    }
    
    private func setupLayout() {
        
    }
}

// MARK: - Favorites tab output impl

extension FavoritesTabViewController: FavoritesTabOutput {}
