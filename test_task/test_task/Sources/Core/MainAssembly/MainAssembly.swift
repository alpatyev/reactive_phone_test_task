import UIKit

// MARK: - Builder for main scene

final class MainAssembly {
    
    // MARK: - Register all dependencies
    
    static func registerDependencies() {
        DependencyContainer.shared.register(type: SearchTabInput.self, component: SearchTabPresenter())
        DependencyContainer.shared.register(type: SearchTabOutput.self, component: SearchTabViewController())
        
        DependencyContainer.shared.register(type: FavoritesTabInput.self, component: FavoritesTabPresenter())
        DependencyContainer.shared.register(type: FavoritesTabOutput.self, component: FavoritesTabViewController())
    }
    
    // MARK: - Create main viewController
    
    static func resolveMainScene() -> UIViewController? {
        let search = DependencyContainer.shared.resolve(type: SearchTabOutput.self) as? UIViewController
        let favorites = DependencyContainer.shared.resolve(type: FavoritesTabOutput.self) as? UIViewController
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [search, favorites].compactMap { $0 }
        
        return UINavigationController(rootViewController: tabBarController)
    }
}
