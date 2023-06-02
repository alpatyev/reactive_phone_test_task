import XCTest

// MARK: - Simple template

struct SearchTabTemplate {
    
    let app: XCUIApplication
    
    var searchTextFieldContainer: XCUIElement {
        return app.descendantElement(matching: .other, "searchTextFieldContainer")
    }
    
    var searchTextField: XCUIElement {
        app.descendantElement(matching: .textField, "searchTextField")
    }
    
    var removeButton: XCUIElement {
        app.descendantElement(matching: .button, "removeButton")
    }
    
    var saveButton: XCUIElement {
        app.descendantElement(matching: .button, "saveButton")
    }
    
    init(_ application: XCUIApplication) {
        app = application
    }
}

// MARK: - Helper

extension XCUIElement {
    func descendantElement(matching elementType: XCUIElement.ElementType,
                           _ identifier: String? = nil) -> XCUIElement {
        var query = descendants(matching: elementType)
        if let identifier = identifier {
            let predicate = NSPredicate(format: "identifier == '\(identifier)'")
            query = query.matching(predicate)
        }
        return query.element
    }
}
