//
//  DetectThePicUITestsLaunchTests.swift
//  DetectThePicUITests
//
//  Created by Tyler Hill on 6/29/23.
//

import XCTest

final class DetectThePicUITestsLaunchTests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = true
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()
        
        try app.performAccessibilityAudit()


    }
}
