import XCTest
@testable import test_task

// MARK: - DI container

final class DependencyContainerTests: XCTestCase {
    
    // MARK: - Properties
    
    var container: DependencyContainer!

    // MARK: - Setup
    
    override func setUp() {
        super.setUp()
        container = DependencyContainer.shared
    }
    
    override func tearDown() {
        container = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func test_register_network_service() {
        let networkService = NetworkService()
        
        container.register(type: NetworkServiceProtocol.self, component: networkService)
        let resolvedComponent = container.resolve(type: NetworkServiceProtocol.self)
        
        XCTAssertNotNil(resolvedComponent)
        XCTAssertTrue(networkService === resolvedComponent)
    }
    
    func test_register_storage_data_service() {
        let storageService = StorageDataService()
        
        container.register(type: StorageDataServiceProtocol.self, component: storageService)
        let resolvedComponent = container.resolve(type: StorageDataServiceProtocol.self)
        
        XCTAssertNotNil(resolvedComponent)
        XCTAssertTrue(storageService === resolvedComponent)
    }
    
    func test_register_search_tab_presenter_view_input() {
        let searchPresenter = SearchTabPresenter()
        
        container.register(type: SearchTabInput.self, component: searchPresenter)
        let resolvedComponent = container.resolve(type: SearchTabInput.self) as AnyObject?
        
        XCTAssertNotNil(resolvedComponent)
        XCTAssertTrue(searchPresenter === resolvedComponent)
    }
    
    func test_register_search_tab_presenter_image_view_input() {
        let searchPresenter = SearchTabPresenter()
        
        container.register(type: SearchTabSelectedImageInput.self, component: searchPresenter)
        let resolvedComponent = container.resolve(type: SearchTabSelectedImageInput.self) as AnyObject?
        
        XCTAssertNotNil(resolvedComponent)
        XCTAssertTrue(searchPresenter === resolvedComponent)
    }
    
    func test_register_favorites_tab_presenter_view_input() {
        let favoritesPresenter = FavoritesTabPresenter()
        
        container.register(type: FavoritesTabInput.self, component: favoritesPresenter)
        let resolvedComponent = container.resolve(type: FavoritesTabInput.self) as AnyObject?

        XCTAssertNotNil(resolvedComponent)
        XCTAssertTrue(favoritesPresenter === resolvedComponent)
    }
    
    func test_register_search_tab__view_output() {
        let favoritesPresenter = SearchTabViewController()
        
        container.register(type: SearchTabOutput.self, component: favoritesPresenter)
        let resolvedComponent = container.resolve(type: SearchTabOutput.self) as AnyObject?

        XCTAssertNotNil(resolvedComponent)
        XCTAssertTrue(favoritesPresenter === resolvedComponent)
    }
    
    func test_register_favorites_tab__view_output() {
        let favoritesPresenter = FavoritesTabViewController()
        
        container.register(type: FavoritesTabOutput.self, component: favoritesPresenter)
        let resolvedComponent = container.resolve(type: FavoritesTabOutput.self) as AnyObject?

        XCTAssertNotNil(resolvedComponent)
        XCTAssertTrue(favoritesPresenter === resolvedComponent)
    }
}
