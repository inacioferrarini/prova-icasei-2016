import UIKit

class ViewControllerManager: NSObject {

    func movieDetailViewController(appContext: AppContext!) -> MovieDetailViewController {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let movieDetailViewController = storyBoard.instantiateViewControllerWithIdentifier("MovieDetailViewController") as! MovieDetailViewController
        movieDetailViewController.appContext = appContext
        return movieDetailViewController
    }

    
}
