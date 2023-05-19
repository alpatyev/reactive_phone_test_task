import UIKit

// MARK: - Application delegate entry

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    private let networkService = NetworkService()
    private let storageService = StorageDataService()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        MainAssembly.registerDependencies()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = MainAssembly.resolveMainScene()
        window?.makeKeyAndVisible()
        
        return true
    }
}
