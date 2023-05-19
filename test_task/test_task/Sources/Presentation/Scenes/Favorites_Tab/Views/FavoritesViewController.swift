import UIKit

// MARK: - Favorites tab output protocol

protocol FavoritesTabOutput: AnyObject {
    func updateState(with newState: FavoritesTabStateModel)
    func updateNavigationBarState(with newState: NavigationBarInfoButtonStateModel)
    func toggleUserInteractions(with flag: Bool)
    func selectedTabBarIndex(_ index: Int)
}

// MARK: - Favorites tab ViewController

final class FavoritesTabViewController: UIViewController {
    
    // MARK: - Presenter
    
    private var presenter: FavoritesTabInput?
    
    // MARK: - UI
    
    private lazy var favoritesList: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: imageCellID)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var listStatusLabel: UILabel = {
        let label = UILabel()
        label.setStandardAppearance()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Private properties
    
    private let imageCellID = "imageCell"
    private var itemModelsList = [ImageItemModel]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDependencies()
        setupView()
        setupHierarachy()
        setupLayout()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenter?.viewDisappeared()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewAppeared()
    }
    
    // MARK: - Setups
    
    private func setupDependencies() {
        presenter = DependencyContainer.shared.resolve(type: FavoritesTabInput.self)
        presenter?.viewDidLoaded()
    }
    
    private func setupView() {
        view.backgroundColor = Constants.Colors.background
        navigationController?.navigationBar.prefersLargeTitles = true
        setupHolderControllersAppearance(Constants.Text.Favorites_Tab.navigationTitle)
        
        let button = UIBarButtonItem(image: UIImage(named: Constants.ImageNames.info),
                                     style: .plain,
                                     target: self,
                                     action: #selector(tappedNavigationBarInfoButton))
        navigationItem.rightBarButtonItem = button
    }
    
    private func setupHierarachy() {
        view.addSubview(favoritesList)
        view.addSubview(listStatusLabel)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            favoritesList.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            favoritesList.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            favoritesList.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            favoritesList.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            listStatusLabel.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor,
                                               multiplier: Constants.Layout.emdededContentMultiplier / 2),
            listStatusLabel.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor,
                                               multiplier: Constants.Layout.emdededContentMultiplier),
            listStatusLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            listStatusLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    // MARK: - Actions
    
    private func selectedListItem(at indexPath: IndexPath) {
        presenter?.selectedItem(itemModelsList[indexPath.row])
    }
    
    @objc private func tappedNavigationBarInfoButton() {
        presenter?.tappedInfoButton()
    }
}

// MARK: - TableView datasource & delegate

extension FavoritesTabViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemModelsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: imageCellID, for: indexPath)
        let itemModel = itemModelsList[indexPath.row]
        cell.setup(with: itemModel)
        return cell
    }
}

extension FavoritesTabViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.Layout.defaultRowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.selectedItem(itemModelsList[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Favorites tab output impl

extension FavoritesTabViewController: FavoritesTabOutput {
    func updateState(with newState: FavoritesTabStateModel) {
        switch newState {
            case .message(let message):
                performEmptyState(message)
            case .itemList(let items):
                updateFavoritesList(items)
        }
    }
    
    func toggleUserInteractions(with flag: Bool) {
        view.isUserInteractionEnabled = flag
    }
    
    func updateNavigationBarState(with newState: NavigationBarInfoButtonStateModel) {
        switch newState {
            case .info(let message):
                performNavigationBarInfoState(message)
            case .list:
                performNavigationBarListState()
        }
    }
    
    func selectedTabBarIndex(_ index: Int) {
        tabBarController?.selectedIndex = index
    }
    
    private func performEmptyState(_ message: String) {
        favoritesList.isHidden = true
        listStatusLabel.isHidden = false
        
        listStatusLabel.text = message
    }
    
    private func updateFavoritesList(_ items: [ImageItemModel]) {
        favoritesList.isHidden = false
        listStatusLabel.isHidden = true
        
        itemModelsList = items
        favoritesList.reloadData()
        presenter?.reportedDisplayedItemsCount(itemModelsList.count)
    }
    
    private func performNavigationBarInfoState(_ message: String) {
        favoritesList.isHidden = true
        listStatusLabel.isHidden = false
        listStatusLabel.text = message
        
        navigationItem.rightBarButtonItem?.image = UIImage(named: Constants.ImageNames.list)
    }
    
    private func performNavigationBarListState() {
        favoritesList.isHidden = false
        listStatusLabel.isHidden = true
        
        navigationItem.rightBarButtonItem?.image = UIImage(named: Constants.ImageNames.info)
    }
}
