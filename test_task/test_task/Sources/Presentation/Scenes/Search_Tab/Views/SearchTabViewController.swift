import UIKit

// MARK: - Search tab output protocol

protocol SearchTabOutput: AnyObject {
    func closeKeyboard()
    func updateState(with newState: SearchTabStateModel)
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
        textField.font = Constants.Fonts.subTitle
        textField.textColor = Constants.Colors.primaryText
        textField.setPlaceholder(text: Constants.Text.Search_Tab.placeholder,
                                 color: Constants.Colors.secondaryText)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var imageContainer: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = Constants.Colors.backgroundAccent
        imageView.layer.cornerRadius = Constants.Layout.mediumCornerRadius
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var imageStatusLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 4
        label.font = Constants.Fonts.title
        label.textColor = Constants.Colors.accent
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var imageLoadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .gray
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
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
        
        let titleAttributes = [NSAttributedString.Key.foregroundColor: Constants.Colors.accent]
        
        if #available(iOS 15.0, *) {
            let tabBarAppearance = UITabBarAppearance()
            let navigationBarAppearance = UINavigationBarAppearance()
            
            navigationBarAppearance.titleTextAttributes = titleAttributes
        
            tabBarController?.tabBar.standardAppearance = tabBarAppearance
            tabBarController?.tabBar.scrollEdgeAppearance = tabBarAppearance
            navigationController?.navigationBar.standardAppearance = navigationBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        } else {
            navigationController?.navigationBar.titleTextAttributes = titleAttributes
        }
    
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let cv = UIViewController()
            cv.view.backgroundColor  = .white
            self.navigationController?.pushViewController(cv, animated: true)
        }
        
        tabBarController?.tabBar.tintColor = Constants.Colors.accent
        navigationController?.navigationBar.tintColor = Constants.Colors.accent
        navigationItem.title = Constants.Text.Search_Tab.navigationTitle
    }
    
    private func setupHierarachy() {
        view.addSubview(searchTextFieldContainer)
        searchTextFieldContainer.addSubview(searchTextField)
        
        view.addSubview(imageContainer)
        imageContainer.addSubview(imageStatusLabel)
        imageContainer.addSubview(imageLoadingIndicator)
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
            imageContainer.topAnchor.constraint(equalTo: searchTextFieldContainer.bottomAnchor,
                                                      constant: Constants.Layout.mediumPadding),
            imageContainer.widthAnchor.constraint(equalTo: view.widthAnchor,
                                                        multiplier: Constants.Layout.emdededContentMultiplier),
            imageContainer.heightAnchor.constraint(equalTo: view.widthAnchor,
                                                         multiplier: Constants.Layout.emdededContentMultiplier),
            imageContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            imageStatusLabel.widthAnchor.constraint(equalTo: imageContainer.widthAnchor,
                                                    multiplier: Constants.Layout.emdededContentMultiplier),
            imageStatusLabel.heightAnchor.constraint(equalTo: imageContainer.heightAnchor,
                                                     multiplier: Constants.Layout.emdededContentMultiplier),
            imageStatusLabel.centerXAnchor.constraint(equalTo: imageContainer.centerXAnchor),
            imageStatusLabel.centerYAnchor.constraint(equalTo: imageContainer.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            imageLoadingIndicator.centerXAnchor.constraint(equalTo: imageContainer.centerXAnchor),
            imageLoadingIndicator.centerYAnchor.constraint(equalTo: imageContainer.centerYAnchor)
        ])
    }
}

// MARK: - Search tab output impl

extension SearchTabViewController: SearchTabOutput {
    func updateState(with newState: SearchTabStateModel) {        
        switch newState {
            case .noImage(let label):
                print("> noImage \(label)")
                imageStatusLabel.text = label
                imageStatusLabel.isHidden = false
                imageLoadingIndicator.stopAnimating()
            case .loading:
                print("> loading")
                imageLoadingIndicator.startAnimating()
                imageStatusLabel.isHidden = true
            case .loadedImage(let imageData):
                print("> loadedImage \(imageData)")
                imageContainer.image = UIImage(data: imageData)
                imageStatusLabel.isHidden = true
                imageLoadingIndicator.stopAnimating()
        }
    }
    
    func closeKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - Search TextField delegate

extension SearchTabViewController: UISearchTextFieldDelegate {}
