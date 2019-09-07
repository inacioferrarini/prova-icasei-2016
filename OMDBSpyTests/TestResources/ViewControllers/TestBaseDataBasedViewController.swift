import UIKit
@testable import OMDBSpy

class TestBaseDataBasedViewController: BaseDataBasedViewController {
    
    override func shouldSyncData() -> Bool {
        return true
    }
    
}
