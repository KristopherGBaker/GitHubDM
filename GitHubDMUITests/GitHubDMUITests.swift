//
//  GitHubDMUITests.swift
//  GitHubDMUITests
//
//  Created by Kris Baker on 9/5/18.
//  Copyright © 2018 Kristopher Baker. All rights reserved.
//

import XCTest

class GitHubDMUITests: XCTestCase {
    
    /// Very simple UI test.
    func testUI() {
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launch()
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["@mojombo"]/*[[".cells.staticTexts[\"@mojombo\"]",".staticTexts[\"@mojombo\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.textViews["MessageInput"].tap()
        app.textViews["MessageInput"].typeText("Hello!")
        app.buttons["Post"].tap()
        app.navigationBars["@mojombo"].buttons["More Info"].tap()
        app/*@START_MENU_TOKEN@*/.otherElements["URL"]/*[[".buttons[\"Address\"]",".otherElements[\"Address\"]",".otherElements[\"URL\"]",".buttons[\"URL\"]"],[[[-1,2],[-1,1],[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
    }
    
}
