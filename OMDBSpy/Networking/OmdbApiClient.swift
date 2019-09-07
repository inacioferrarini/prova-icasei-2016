import UIKit
import EasyMapping
import AFNetworking

class OmdbApiClient: NSObject {

    let rootUrl = "http://www.omdbapi.com/"
    let appContext:AppContext
    
    init(appContext:AppContext) {
        self.appContext = appContext
        super.init()
    }
    
    func searchMovie(title:String, atPage page:Int, completionBlock: ((Int, [OmdbMovie]?) -> Void), errorHandlerBlock: ((NSError) -> Void)) {
        
        let successBlock = { (dataTask: NSURLSessionDataTask, responseObject:AnyObject?) -> Void in
            if let dictionary = responseObject as? [String : AnyObject] {
                let context = self.appContext.coreDataStack.managedObjectContext
                let searchResults = dictionary["Search"] as! [[String : AnyObject]]
                var totalResults = 0
                if let totalResultsJson = dictionary["totalResults"] as? String {
                    totalResults = Int(totalResultsJson) ?? 0
                }
                
                let movies = EKManagedObjectMapper.arrayOfObjectsFromExternalRepresentation(searchResults, withMapping: MapperManager.omdbMovieSearchObjectMapping(), inManagedObjectContext: context) as? [OmdbMovie]
                self.appContext.coreDataStack.saveContext()
                
                completionBlock(totalResults, movies)
            }
        }
        
        let failureBlock = { (dataTask: NSURLSessionDataTask?, error: NSError) -> Void in
            errorHandlerBlock(error)
        }
        
        if let url = NSURL(string: rootUrl) {
            let manager = AFHTTPSessionManager(baseURL: url)
            let targetUrl = "?s={:title}"
                .stringByReplacingOccurrencesOfString("{:title}", withString: "\(title)")
            manager.GET(targetUrl, parameters: nil, progress: nil, success: successBlock, failure: failureBlock)
        }
    }
    
    func fetchMovie(title:String, completionBlock: ((OmdbMovie?) -> Void), errorHandlerBlock: ((NSError) -> Void)) {
        
        let successBlock = { (dataTask: NSURLSessionDataTask, responseObject:AnyObject?) -> Void in
            if let dictionary = responseObject as? [String : AnyObject] {
                let context = self.appContext.coreDataStack.managedObjectContext
                let movie =
                EKManagedObjectMapper.objectFromExternalRepresentation(dictionary, withMapping: MapperManager.omdbMovieObjectMapping(), inManagedObjectContext: context) as? OmdbMovie
                self.appContext.coreDataStack.saveContext()
                
                completionBlock(movie)
            }
        }
        
        let failureBlock = { (dataTask: NSURLSessionDataTask?, error: NSError) -> Void in
            errorHandlerBlock(error)
        }
        
        if let url = NSURL(string: rootUrl) {
            let manager = AFHTTPSessionManager(baseURL: url)
            let updatedTitle = title.stringByReplacingOccurrencesOfString(" ", withString: "+")
            let targetUrl = "?t={:title}"
                .stringByReplacingOccurrencesOfString("{:title}", withString: "\(updatedTitle)")
            manager.GET(targetUrl, parameters: nil, progress: nil, success: successBlock, failure: failureBlock)
        }
    }
    
}
