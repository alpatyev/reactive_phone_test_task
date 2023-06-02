import XCTest
@testable import test_task

// MARK: - Mock network manager

final class MockNetworkService: NetworkServiceProtocol {
    func fetchImage(with prompt: String, _ completion: @escaping (Data?) -> ()) {
        let data = prompt.data(using: .utf8)
        completion(data)
    }
}

// MARK: - Testing

class NetworkService_tests: XCTestCase {
    
    // MARK: - Properties

    var networkService: NetworkServiceProtocol!

    // MARK: - Setup

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        networkService = MockNetworkService()
    }

    override func tearDown() {
        networkService = nil
        super.tearDown()
    }
    
    // MARK: - Tests

    func test_fetch_image() {
        let expectation = XCTestExpectation(description: "Just fetching data here")
        
        networkService.fetchImage(with: "Usual prompt") { data in
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0)
    }
}
