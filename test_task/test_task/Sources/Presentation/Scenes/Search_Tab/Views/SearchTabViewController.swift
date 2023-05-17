import UIKit

// MARK: - Search tab output protocol

protocol SearchTabOutput: AnyObject {}

// MARK: - Search tab ViewController

final class SearchTabViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }
}

// MARK: - Search tab output impl

extension SearchTabViewController: SearchTabOutput {}
