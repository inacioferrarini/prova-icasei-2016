import Foundation
import CoreData
import EasyMapping

class OmdbMovie: EKManagedObjectModel {

    class func fetchOmdbMovieByImdbID(imdbID: String, inManagedObjectContext context:NSManagedObjectContext) -> OmdbMovie? {
        
        guard imdbID.characters.count > 0 else {
            return nil
        }
        
        let request:NSFetchRequest = NSFetchRequest(entityName: self.simpleClassName())
        request.predicate = NSPredicate(format: "imdbID = %@", imdbID)
        
        let matches = (try! context.executeFetchRequest(request)) as! [OmdbMovie]
        if (matches.count > 0) {
            return matches.last
        }
        
        return nil
    }
    
}


