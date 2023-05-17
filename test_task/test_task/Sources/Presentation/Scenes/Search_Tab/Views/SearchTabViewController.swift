import UIKit

// MARK: - Search tab output protocol

protocol SearchTabOutput: AnyObject {}

// MARK: - Search tab ViewController

final class SearchTabViewController: UIViewController {
    
    // MARK: - Presenter
    
    private var presenter: SearchTabInput?
    
    // MARK: - UI
    
    private lazy var searchTextFieldContainer: UIView = {
        let subview = UIView()
        subview.backgroundColor = Constants.Colors.backgroundAccent
        subview.layer.cornerRadius = Constants.Layout.smallCornerRadius
        subview.translatesAutoresizingMaskIntoConstraints = false
        return subview
    }()
    
    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.font = Constants.Fonts.body
        textField.textColor = Constants.Colors.primaryText
        textField.backgroundColor = Constants.Colors.backgroundAccent
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var highlightedContainer: UIView = {
        let subview = UIView()
        subview.backgroundColor = Constants.Colors.backgroundAccent
        subview.layer.cornerRadius = Constants.Layout.mediumCornerRadius
        subview.translatesAutoresizingMaskIntoConstraints = false
        return subview
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupHierarachy()
        setupLayout()
    }
    
    // MARK: - Setups
    
    private func setupView() {
        view.backgroundColor = Constants.Colors.background
    }
    
    private func setupHierarachy() {
        view.addSubview(searchTextFieldContainer)
        searchTextFieldContainer.addSubview(searchTextField)
        
        view.addSubview(highlightedContainer)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            searchTextFieldContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                                 constant: Constants.Layout.smallPadding),
            searchTextFieldContainer.leftAnchor.constraint(equalTo: view.leftAnchor,
                                                  constant: Constants.Layout.smallPadding),
            searchTextFieldContainer.rightAnchor.constraint(equalTo: view.rightAnchor,
                                                   constant: -Constants.Layout.smallPadding),
            searchTextFieldContainer.heightAnchor.constraint(equalToConstant: Constants.Layout.smallElementHeight)
        ])
        
        NSLayoutConstraint.activate([
            searchTextField.widthAnchor.constraint(equalTo: searchTextFieldContainer.widthAnchor,
                                                    multiplier: Constants.Layout.emdededContentMultiplier),
            searchTextField.heightAnchor.constraint(equalTo: searchTextFieldContainer.heightAnchor,
                                                    multiplier: Constants.Layout.emdededContentMultiplier),
            searchTextField.centerXAnchor.constraint(equalTo: searchTextFieldContainer.centerXAnchor),
            searchTextField.centerYAnchor.constraint(equalTo: searchTextFieldContainer.centerYAnchor)

        ])
        
        NSLayoutConstraint.activate([
            highlightedContainer.topAnchor.constraint(equalTo: searchTextFieldContainer.bottomAnchor,
                                                      constant: Constants.Layout.mediumPadding),
            highlightedContainer.widthAnchor.constraint(equalTo: view.widthAnchor,
                                                        multiplier: Constants.Layout.emdededContentMultiplier),
            highlightedContainer.heightAnchor.constraint(equalTo: view.widthAnchor,
                                                         multiplier: Constants.Layout.emdededContentMultiplier),
            highlightedContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

// MARK: - Search tab output impl

extension SearchTabViewController: SearchTabOutput {}

// MARK: - Search TextField delegate

extension SearchTabViewController: UISearchTextFieldDelegate {}
