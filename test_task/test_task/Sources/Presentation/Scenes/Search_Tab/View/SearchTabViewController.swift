import UIKit

// MARK: - Search tab output protocol

protocol SearchTabOutput: AnyObject {
    func closeKeyboard()
    func updateState(with newState: SearchTabStateModel)
    func setRemoveButtonEnabled(_ flag: Bool)
    func showAlertMessage(messageTitle: String, closeTitle: String)
    func updateTextField(with text: String)
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
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = Constants.Colors.backgroundAccent
        imageView.layer.borderWidth = Constants.Layout.defaultBorderWidth
        imageView.layer.cornerRadius = Constants.Layout.mediumCornerRadius
        imageView.layer.borderColor = Constants.Colors.accent.withAlphaComponent(0.6).cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var imageStatusLabel: UILabel = {
        let label = UILabel()
        label.setStandardAppearance()
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
    
    private lazy var saveImageButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = Constants.Fonts.thin
        button.highlightable(accentColor: Constants.Colors.accent,
                             title: Constants.Text.Search_Tab.saveButton)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var removeImageButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = Constants.Fonts.thin
        button.highlightable(accentColor: Constants.Colors.destructive,
                             title: Constants.Text.Search_Tab.removeButton)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.addTarget(self, action: #selector(removeButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var clearDataButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.Text.Search_Tab.clearDataButton, for: .normal)
        button.setTitleColor(Constants.Colors.secondaryText.withAlphaComponent(0.4), for: .normal)
        button.setTitleColor(Constants.Colors.accent, for: .highlighted)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
        navigationController?.navigationBar.prefersLargeTitles = false
        setupHolderControllersAppearance(Constants.Text.Search_Tab.navigationTitle)
    }
    
    private func setupHierarachy() {
        view.addSubview(searchTextFieldContainer)
        searchTextFieldContainer.addSubview(searchTextField)
        
        view.addSubview(imageContainer)
        imageContainer.addSubview(imageStatusLabel)
        imageContainer.addSubview(imageLoadingIndicator)
        
        view.addSubview(saveImageButton)
        view.addSubview(removeImageButton)
        view.addSubview(clearDataButton)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            searchTextFieldContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                                 constant: Constants.Layout.smallPadding),
            searchTextFieldContainer.widthAnchor.constraint(equalTo: view.widthAnchor,
                                                            multiplier: Constants.Layout.emdededContentMultiplier),
            searchTextFieldContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
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
                                                      constant: Constants.Layout.smallPadding),
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
        
        NSLayoutConstraint.activate([
            removeImageButton.topAnchor.constraint(equalTo: imageContainer.bottomAnchor,
                                                   constant: Constants.Layout.smallPadding),
            removeImageButton.leftAnchor.constraint(equalTo: imageContainer.leftAnchor,
                                                    constant: Constants.Layout.smallPadding),
            removeImageButton.widthAnchor.constraint(equalToConstant: Constants.Layout.smallElementHeight * 2.2),
            removeImageButton.heightAnchor.constraint(equalToConstant: Constants.Layout.smallElementHeight)
        ])
        
        NSLayoutConstraint.activate([
            saveImageButton.topAnchor.constraint(equalTo: imageContainer.bottomAnchor,
                                                 constant: Constants.Layout.smallPadding),
            saveImageButton.rightAnchor.constraint(equalTo: imageContainer.rightAnchor,
                                                   constant: -Constants.Layout.smallPadding),
            saveImageButton.widthAnchor.constraint(equalToConstant: Constants.Layout.smallElementHeight * 2.2),
            saveImageButton.heightAnchor.constraint(equalToConstant: Constants.Layout.smallElementHeight)
        ])
        
        NSLayoutConstraint.activate([
            clearDataButton.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor,
                                                   constant: -Constants.Layout.smallPadding),
            clearDataButton.widthAnchor.constraint(equalTo: view.widthAnchor,
                                                     multiplier: Constants.Layout.emdededContentMultiplier),
            clearDataButton.heightAnchor.constraint(equalToConstant: Constants.Layout.smallElementHeight),
            clearDataButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func removeButtonTapped() {
        presenter?.removeButtonTapped()
    }
    
    @objc private func saveButtonTapped() {
        presenter?.saveButtonTapped()
    }
    
    @objc private func clearButtonTapped() {
        presenter?.clearAllDataButtonTapped()
    }
}

// MARK: - Search tab output impl

extension SearchTabViewController: SearchTabOutput {
    func updateState(with newState: SearchTabStateModel) {        
        switch newState {
            case .noImage(let label):
                performNoImageState(label)
            case .loading:
                performLoadingState()
            case .loadedImage(let imageData):
                performLoadedImageState(imageData)
        }
    }
    
    func closeKeyboard() {
        view.endEditing(true)
    }
    
    func setRemoveButtonEnabled(_ flag: Bool) {
        flag ? performStandardRemoveButton() : performDisabledRemoveButton()
    }
    
    func showAlertMessage(messageTitle: String, closeTitle: String) {
        let alertController = UIAlertController(title: nil, message: messageTitle, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: closeTitle, style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func updateTextField(with text: String) {
        searchTextField.text = text
    }
        
    private func performStandardRemoveButton() {
        removeImageButton.isUserInteractionEnabled = true
        removeImageButton.highlightable(accentColor: Constants.Colors.destructive,
                                        title: Constants.Text.Search_Tab.removeButton)
    }
    
    private func performDisabledRemoveButton(){
        removeImageButton.isUserInteractionEnabled = false
        removeImageButton.highlightable(accentColor: Constants.Colors.backgroundAccent,
                                        title: Constants.Text.Search_Tab.removeButton)
    }
    
    private func performNoImageState(_ label: String) {
        imageStatusLabel.text = label
        imageStatusLabel.isHidden = false
        saveImageButton.isHidden = true
        removeImageButton.isHidden = true
        imageLoadingIndicator.stopAnimating()
        imageContainer.image = UIImage()
    }
    
    private func performLoadingState() {
        imageStatusLabel.isHidden = true
        imageLoadingIndicator.startAnimating()
    }
    
    private func performLoadedImageState(_ imageData: Data) {
        imageContainer.image = UIImage(data: imageData)
        imageStatusLabel.isHidden = true
        saveImageButton.isHidden = false
        removeImageButton.isHidden = false
        imageLoadingIndicator.stopAnimating()
    }
}

// MARK: - Search TextField delegate

extension SearchTabViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        presenter?.textFieldReturned(textField.text)
        return true
    }
}
