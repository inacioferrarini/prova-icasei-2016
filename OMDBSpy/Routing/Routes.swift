import UIKit

class Routes: NSObject {
    
    func initialUrl() -> String {
        return "/"
    }
    
    func showMovieUrl(imdbID: String) -> String {
        return "/movie/" + imdbID
    }
    
}
