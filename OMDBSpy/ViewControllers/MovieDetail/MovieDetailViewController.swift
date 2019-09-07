import UIKit

class MovieDetailViewController: BaseViewController {
    
    @IBOutlet weak var contentView: UIScrollView!
    
    var movie:OmdbMovie?
    
    
    // MARK:- BaseViewController override
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let movie = self.movie {
            self.createUIFromMovie(movie)
        }
    }
    
    func createUIFromMovie(movie:OmdbMovie) {
        let width = self.contentView.frame.width
        var origin = CGPointMake(0, 0)
        let movieDetailPosterView = MovieDetailPosterView(title: movie.title, poster: movie.poster, atOrigin: origin, width: width)
        self.addViewToContentView(self.contentView, view: movieDetailPosterView)
        origin.y = origin.y + movieDetailPosterView.frame.height
        
        
        let movieDescriptionView = MovieDetailDescriptionView(plot: movie.plot, atOrigin: origin, width: width)
        self.addViewToContentView(self.contentView, view: movieDescriptionView)
        origin.y = origin.y + movieDescriptionView.frame.height
        

        
        var field = MovieDetailFieldView(icon: UIImage(named: "ic_people")!, text: movie.actors, atOrigin: origin, width: width)
        self.addViewToContentView(self.contentView, view: field)
        origin.y = origin.y + field.frame.height
        
        field = MovieDetailFieldView(icon: UIImage(named: "ic_videocam")!, text: movie.director, atOrigin: origin, width: width)
        self.addViewToContentView(self.contentView, view: field)
        origin.y = origin.y + field.frame.height

        field = MovieDetailFieldView(icon: UIImage(named: "ic_mode_edit")!, text: movie.writer, atOrigin: origin, width: width)
        self.addViewToContentView(self.contentView, view: field)
        origin.y = origin.y + field.frame.height
        
        field = MovieDetailFieldView(icon: UIImage(named: "ic_date_range")!, text: movie.released, atOrigin: origin, width: width)
        self.addViewToContentView(self.contentView, view: field)
        origin.y = origin.y + field.frame.height
        
        field = MovieDetailFieldView(icon: UIImage(named: "ic_av_timer")!, text: movie.runtime, atOrigin: origin, width: width)
        self.addViewToContentView(self.contentView, view: field)
        origin.y = origin.y + field.frame.height
        
        field = MovieDetailFieldView(icon: UIImage(named: "ic_movie")!, text: movie.genre, atOrigin: origin, width: width)
        self.addViewToContentView(self.contentView, view: field)
        origin.y = origin.y + field.frame.height
        
        field = MovieDetailFieldView(icon: UIImage(named: "ic_star")!, text: movie.imdbVotes, atOrigin: origin, width: width)
        self.addViewToContentView(self.contentView, view: field)
        origin.y = origin.y + field.frame.height
        
        field = MovieDetailFieldView(icon: UIImage(named: "ic_star_border")!, text: movie.awards, atOrigin: origin, width: width)
        self.addViewToContentView(self.contentView, view: field)
        origin.y = origin.y + field.frame.height
        
        field = MovieDetailFieldView(icon: UIImage(named: "ic_room")!, text: movie.country, atOrigin: origin, width: width)
        self.addViewToContentView(self.contentView, view: field)
        origin.y = origin.y + field.frame.height
    }
    
    func addViewToContentView(contentView: UIScrollView, view:UIView) {
        let currentContentSize = contentView.contentSize
        let newContentSize = CGSize(width: currentContentSize.width, height: currentContentSize.height + view.frame.height)
        contentView.addSubview(view)
        contentView.contentSize = newContentSize
    }
    
}
