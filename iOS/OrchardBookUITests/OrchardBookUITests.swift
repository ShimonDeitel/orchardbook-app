import XCTest

final class OrchardBookUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() async throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testAddEntryFlow() {
        app.buttons["addEntryButton"].tap()
        let field = app.textFields["field_treeName"]
        XCTAssertTrue(field.waitForExistence(timeout: 2))
        field.tap()
        field.typeText("UI Test Entry")
        app.buttons["saveEntryButton"].tap()
        XCTAssertTrue(app.staticTexts["UI Test Entry"].waitForExistence(timeout: 2))
    }

    func testKeyboardDismissesOnTapOutside() {
        app.buttons["addEntryButton"].tap()
        let field = app.textFields["field_treeName"]
        XCTAssertTrue(field.waitForExistence(timeout: 2))
        field.tap()
        field.typeText("Some text")
        XCTAssertTrue(app.keyboards.element.exists)
        app.navigationBars.firstMatch.tap()
        XCTAssertFalse(app.keyboards.element.waitForExistence(timeout: 1))
    }

    func testCancelDismissesEditor() {
        app.buttons["addEntryButton"].tap()
        XCTAssertTrue(app.buttons["cancelEntryButton"].waitForExistence(timeout: 2))
        app.buttons["cancelEntryButton"].tap()
        XCTAssertTrue(app.buttons["addEntryButton"].waitForExistence(timeout: 2))
    }

    func testSettingsSheetOpensAndCloses() {
        app.buttons["settingsButton"].tap()
        XCTAssertTrue(app.buttons["settingsDoneButton"].waitForExistence(timeout: 2))
        app.buttons["settingsDoneButton"].tap()
    }

    func testPaywallAppearsAtFreeLimit() {
        for _ in 0..<25 {
            app.buttons["addEntryButton"].tap()
            let field = app.textFields["field_treeName"]
            if field.waitForExistence(timeout: 1) {
                field.tap()
                field.typeText("Entry")
                app.buttons["saveEntryButton"].tap()
            } else if app.buttons["unlockProButton"].waitForExistence(timeout: 1) {
                break
            }
        }
        XCTAssertTrue(app.buttons["unlockProButton"].waitForExistence(timeout: 2))
    }
}
