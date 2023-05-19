import Foundation

// MARK: - Dependency container protocol

protocol DependencyContainerProtocol {
  func register<Component>(type: Component.Type, component: AnyObject)
  func resolve<Component>(type: Component.Type) -> Component?
}

// MARK: - Dependency container implementation

final class DependencyContainer: DependencyContainerProtocol {
    
    // MARK: - Singleton
    
    static let shared = DependencyContainer()
    
    // MARK: - Stored types
    
    private var components: [String: AnyObject] = [:] {
        didSet {
            print(components)
        }
    }

    // MARK: - Init
    
    private init() {}
    
    // MARK: - Register + resolve self/component methods
    
    func register<Component>(type: Component.Type, component: AnyObject) {
        components["\(type)"] = component
    }
    
    func resolve<Component>(type: Component.Type) -> Component? {
        components["\(type)"] as? Component
    }
}
