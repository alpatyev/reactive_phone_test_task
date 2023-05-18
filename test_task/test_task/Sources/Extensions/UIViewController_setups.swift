import UIKit

// MARK: - Setup navigation bar + tab bar

extension UIViewController {
    func setupHolderControllersAppearance(_ title: String) {
        let titleAttributes = [NSAttributedString.Key.foregroundColor: Constants.Colors.accent]
        
        if #available(iOS 15.0, *) {
            let tabBarAppearance = UITabBarAppearance()
            let navigationBarAppearance = UINavigationBarAppearance()
            
            navigationBarAppearance.largeTitleTextAttributes = titleAttributes
            navigationBarAppearance.titleTextAttributes = titleAttributes
        
            tabBarController?.tabBar.standardAppearance = tabBarAppearance
            tabBarController?.tabBar.scrollEdgeAppearance = tabBarAppearance
            navigationController?.navigationBar.standardAppearance = navigationBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        } else {
            navigationController?.navigationBar.largeTitleTextAttributes = titleAttributes
            navigationController?.navigationBar.titleTextAttributes = titleAttributes
        }
    
        tabBarController?.tabBar.tintColor = Constants.Colors.accent
        navigationController?.navigationBar.tintColor = Constants.Colors.accent
        navigationItem.title = title
    }
}
