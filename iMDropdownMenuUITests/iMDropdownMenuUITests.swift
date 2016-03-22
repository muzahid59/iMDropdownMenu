//
//  iMDropdownMenuUITests.swift
//  iMDropdownMenuUITests
//
//  Created by Muzahidul Islam on 3/22/16.
//  Copyright © 2016 iMuzahid. All rights reserved.
//

import XCTest

class iMDropdownMenuUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
	
	func screenCapture(){
		
		
	}
	
    func testExample() {
			
			let app = XCUIApplication()
			let arrowDownButton = app.navigationBars["iMenu"].buttons["arrow down"]
			arrowDownButton.tap()
			app.buttons["Leicester City"].tap()
			arrowDownButton.tap()
			app.buttons["Tottenham"].tap()
			arrowDownButton.tap()
			app.buttons["Man City"].tap()
			arrowDownButton.tap()
			app.buttons["West Ham"].tap()
			
				// Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
}
