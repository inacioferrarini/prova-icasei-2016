import UIKit
import EasyMapping

class MapperManager: NSObject {

    class func omdbMovieSearchObjectMapping() -> EKManagedObjectMapping {
        let mapping = EKManagedObjectMapping(entityName: OmdbMovie.simpleClassName())
        mapping.mapPropertiesFromArray(["Title", "Year", "imdbID", "Type", "Poster"])
        mapping.primaryKey = "imdbID"
        return mapping
    }
    
    class func omdbMovieObjectMapping() -> EKManagedObjectMapping {
        let mapping = EKManagedObjectMapping(entityName: OmdbMovie.simpleClassName())
        mapping.mapPropertiesFromArray(["title", "year", "rated", "released", "runtime", "genre", "director", "writer", "actors", "plot", "language", "country", "awards", "poster", "metascore", "imdbRating", "imdbVotes", "imdbID", "type"])
        mapping.primaryKey = "imdbID"
        return mapping
    }

}
