import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appContext: AppContext?
    
    
    // MARK: - App LifeCycle
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        self.updateStatusBarColor(UIColor(red: 0.247, green: 0.317, blue: 0.709, alpha: 0.50))
        
        if let window = self.window {
            let rootNavigationController = window.rootViewController as! UINavigationController
            var firstViewController = rootNavigationController.topViewController as! AppContextAwareProtocol
            
            let logger = Logger()
            let stack = CoreDataStack(modelFileName: "OMDBSpy", databaseFileName: "OMDBSpy", logger: logger)
            let router = NavigationRouter(schema: "OMDBSpy", logger: logger)
            let syncRulesStack = CoreDataStack(modelFileName: "DataSyncRules", databaseFileName: "DataSyncRules", logger: logger)
            let syncRules = DataSyncRules(coreDataStack: syncRulesStack)
            
            self.appContext = AppContext(navigationController: rootNavigationController,
                coreDataStack: stack,
                syncRules: syncRules,
                router: router,
                logger: logger)
            
            firstViewController.appContext = self.appContext
            router.registerRoutes(self.createNavigationRoutes())
            
            self.addSyncRules(syncRules)
        }
        
        return true
    }
    
    func applicationWillTerminate(application: UIApplication) {
        if let appContext = self.appContext {
            appContext.coreDataStack.saveContext()
        }
    }
    
    
    // MARK: - Deep Linking Navigation
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        
        if let appContext = self.appContext {
            return appContext.router.dispatch(url)
        }
        
        return true
    }
    
    func application(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]?) -> Void) -> Bool {
        
        if let url = userActivity.webpageURL,
            let appContext = self.appContext {
                return appContext.router.dispatch(url)
        }
        
        return true
    }
    
    
    // MARK: - UI Theme
    
    func updateStatusBarColor(color: UIColor) {
        guard let statusBar = UIApplication.sharedApplication().valueForKey("statusBarWindow")?.valueForKey("statusBar") as? UIView else {
            return
        }
        statusBar.backgroundColor = color
    }
    
    
    // MARK: - AppContext Setup
    
    func createNavigationRoutes() -> [RoutingElement] {
        
        var routes = [RoutingElement]()
        
        routes.append(RoutingElement(pattern: "/", handler: { (params: [NSObject : AnyObject]) -> Bool in
            return true
        }))
        
        routes.append(RoutingElement(pattern: "/movie/:imdbID", handler: { (params: [NSObject : AnyObject]) -> Bool in
            guard let imdbID = params["imdbID"] as? String else { return false }
            
            if let appContext = self.appContext {
                let context = appContext.coreDataStack.managedObjectContext
                let viewController = ViewControllerManager().movieDetailViewController(appContext)
                if let movie = OmdbMovie.fetchOmdbMovieByImdbID(imdbID, inManagedObjectContext: context) {
                    viewController.movie = movie
                }
                appContext.navigationController.presentViewController(viewController, animated: true, completion: nil)
            }
            
            return true
        }))
        
        return routes
    }
    
    func addSyncRules(syncRules: DataSyncRules) {
    }
    
}

