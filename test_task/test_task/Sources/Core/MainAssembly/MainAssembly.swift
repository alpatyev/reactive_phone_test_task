import UIKit

// MARK: - Builder for main scene

final class MainAssembly {
    
    // MARK: - Register all dependencies
    
    static func registerDependencies() {
        DependencyContainer.shared.register(type: SearchTabInput.self, component: SearchTabPresenter())
        DependencyContainer.shared.register(type: SearchTabOutput.self, component: SearchTabViewController())
        
        DependencyContainer.shared.register(type: FavoritesTabInput.self, component: FavoritesTabPresenter())
        DependencyContainer.shared.register(type: FavoritesTabOutput.self, component: FavoritesTabViewController())
        
        DependencyContainer.shared.register(type: NetworkServiceProtocol.self, component: NetworkService())
        DependencyContainer.shared.register(type: StorageDataServiceProtocol.self, component: StorageDataService())
    }
    
    // MARK: - Create main viewController
    
    static func resolveMainScene() -> UIViewController? {
        if let search = DependencyContainer.shared.resolve(type: SearchTabOutput.self) as? UIViewController,
           let favorites = DependencyContainer.shared.resolve(type: FavoritesTabOutput.self) as? UIViewController {
            search.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "sparkle.magnifyingglass"), tag: 0)
            favorites.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "star.fill"), tag: 1)

            let embeddedSearch = UINavigationController(rootViewController: search)
            let embeddedFavorites = UINavigationController(rootViewController: favorites)
            
            let tabBarController = UITabBarController()
            tabBarController.viewControllers = [embeddedSearch, embeddedFavorites]
            return tabBarController
        } else {
            return nil
        }
    }
}
