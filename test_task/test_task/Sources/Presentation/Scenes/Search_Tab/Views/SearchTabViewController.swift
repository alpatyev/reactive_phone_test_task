import UIKit

// MARK: - Search tab output protocol

protocol SearchTabOutput: AnyObject {
    func closeKeyboard()
}

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
        textField.textAlignment = .center
        textField.keyboardType = .alphabet
        textField.returnKeyType = .search
        textField.font = Constants.Fonts.body
        textField.textColor = Constants.Colors.primaryText
        textField.setPlaceholder(text: Constants.Text.Search_Tab.placeholder,
                                 color: Constants.Colors.secondaryText)
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
        setupDependecies()
        setupView()
        setupHierarachy()
        setupLayout()
    }
    
    // MARK: - Setups
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        presenter?.tappedSomewhere()
    }
    
    private func setupDependecies() {
        presenter = DependencyContainer.shared.resolve(type: SearchTabInput.self)
        presenter?.viewDidLoaded()
    }
    
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
            searchTextField.leftAnchor.constraint(equalTo: searchTextFieldContainer.leftAnchor,
                                                  constant: Constants.Layout.smallPadding),
            searchTextField.rightAnchor.constraint(equalTo: searchTextFieldContainer.rightAnchor,
                                                   constant: -Constants.Layout.smallPadding),
            searchTextField.heightAnchor.constraint(equalTo: searchTextFieldContainer.heightAnchor,
                                                    multiplier: Constants.Layout.emdededContentMultiplier),
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

extension SearchTabViewController: SearchTabOutput {
    func closeKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - Search TextField delegate

extension SearchTabViewController: UISearchTextFieldDelegate {}
