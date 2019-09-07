import XCTest
@testable import OMDBSpy

class NSObjectExtensionsTests: XCTestCase {
    
    func test_simpleClassName_mustReturnName() {
        let simpleClassName = AppContext.simpleClassName()
        let name = "AppContext"
        XCTAssertEqual(simpleClassName, name)
    }
    
}