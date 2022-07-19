//
//  ToDoUITests.swift
//  ToDoUITests
//
//  Created by Stanly Shiyanovskiy on 19.07.2022.
//

import XCTest

final class ToDoUITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testExample() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.navigationBars["ToDo.ItemListView"].buttons["Add"].tap()
        
        let titleTextField = app.textFields["Title"]
        titleTextField.tap()
        titleTextField.typeText("Meeting")

        let dateTextField = app.textFields["Date"]
        dateTextField.tap()
        dateTextField.typeText("02/22/2018")

        let locationNameTextField = app.textFields["Location"]
        locationNameTextField.tap()
        locationNameTextField.typeText("Office")

        let addressTextField = app.textFields["Address"]
        addressTextField.tap()
        addressTextField.typeText("Infinite Loop 1, Cupertino")

        let descriptionTextField = app.textFields["Description"]
        descriptionTextField.tap()
        descriptionTextField.typeText("Bring iPad")
        app.buttons["Save"].tap()
                
        XCTAssertTrue(app.tables.staticTexts["Meeting"].exists)
        XCTAssertTrue(app.tables.staticTexts["02/22/2018"].exists)
        XCTAssertTrue(app.tables.staticTexts["Office"].exists)
    }
}
