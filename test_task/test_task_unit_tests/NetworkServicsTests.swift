import XCTest
@testable import test_task

// MARK: - Main network manager

class NetworkService_tests: XCTestCase {
    
    // MARK: - Properties

    var networkService: NetworkService!

    // MARK: - Setup

    override func setUp() {
        super.setUp()
        networkService = NetworkService()
    }

    override func tearDown() {
        networkService = nil
        super.tearDown()
    }
    
    // MARK: - Tests

    func test_fetch_image() {
        let expectation = XCTestExpectation(description: "Just fetching data here")
        
        networkService.fetchImage(with: "Travis Skott") { data in
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 4)
    }
}
