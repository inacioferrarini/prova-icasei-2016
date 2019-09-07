import XCTest
@testable import OMDBSpy

class LoggerTests: XCTestCase {
    
    func test_logger_mustNotCrash() {
        Logger().logErrorMessage("Error Message")
    }
    
}
