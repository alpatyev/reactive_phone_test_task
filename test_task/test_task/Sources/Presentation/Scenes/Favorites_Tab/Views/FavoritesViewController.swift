import UIKit

// MARK: - Favorites tab output protocol

protocol FavoritesTabOutput: AnyObject {}

// MARK: - Favorites tab ViewController

final class FavoritesTabViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
    }
}

// MARK: - Favorites tab output impl

extension FavoritesTabViewController: FavoritesTabOutput {}
