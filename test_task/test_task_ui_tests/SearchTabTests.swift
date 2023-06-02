import XCTest

// MARK: - Search tab simple tests

final class SearchTabTests: XCTestCase {
    
    var application = XCUIApplication()
    var template: SearchTabTemplate!
    
    override func setUpWithError() throws {
        application.launch()
        template = SearchTabTemplate(application)
    }
    
    override func tearDownWithError() throws {
        application.terminate()
    }
    
    // MARK: - Tests
    
    func test_textfield_container_accessible() {
        let container = template.searchTextFieldContainer
        XCTAssert(container.exists, "searchTextFieldContainer not exists")

        let textField = template.searchTextField
        XCTAssert(textField.exists, "searchTextField not exists")
    }
    
    func test_keyboard_accessible() {
        let textField = template.searchTextField
        textField.tap()

        XCTAssert(application.keyboards.count > 0, "searchTextField not triggering keyboard")
        
        textField.typeText("/n")
    }
}
