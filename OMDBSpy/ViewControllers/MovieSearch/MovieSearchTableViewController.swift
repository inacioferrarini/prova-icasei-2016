import UIKit
import SDWebImage

enum SearchBarStatus {
    case Normal
    case Searching
}


class MovieSearchTableViewController: BaseTableViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var leftBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var rightBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var searchInfoView: UIView!
    @IBOutlet weak var containerView: UIView!
    
    var resultHeader: MovieListTableViewHeader!
    var status:SearchBarStatus!
    
    // MARK: - BaseTableViewController Override Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.status = .Normal
        self.resultHeader = MovieListTableViewHeader()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.deregisterFromKeyboardNotifications()
        super.viewWillDisappear(animated)
    }
    
    override func shouldSyncData() -> Bool {
        return false
    }
    
    override func createDataSource() -> UITableViewDataSource? {
        
        let presenter = TableViewCellPresenter<MovieListTableViewCell, OmdbMovie> (
            configureCellBlock: { (cell: MovieListTableViewCell, entity: OmdbMovie) -> Void in
                if let posterUrl = entity.poster,
                    let url = NSURL(string: posterUrl) {
                    cell.posterImage.sd_setImageWithURL(url)
                }
                cell.movieTitle.text = entity.title ?? ""
                cell.movieDescription.text = entity.plot ?? ""
            }, cellReuseIdentifier: MovieListTableViewCell.simpleClassName())
        
        let sortDescriptors:[NSSortDescriptor] = []
        let context = self.appContext.coreDataStack.managedObjectContext
        let logger = appContext.logger

        let dataSource = FetcherDataSource<MovieListTableViewCell, OmdbMovie>(
            targetingTableView: self.tableView!,
            presenter: presenter,
            entityName: OmdbMovie.simpleClassName(),
            sortDescriptors: sortDescriptors,
            managedObjectContext: context,
            logger: logger)
        
        dataSource.refreshData()
        
        return dataSource
    }
    
    override func createDelegate() -> UITableViewDelegate? {
        
        let itemSelectionBlock = { (indexPath:NSIndexPath) -> Void in
            if let dataSource = self.dataSource as? FetcherDataSource<MovieListTableViewCell, OmdbMovie> {
                let selectedValue = dataSource.objectAtIndexPath(indexPath)
                if let title = selectedValue.title {
                    self.searchMovie(title)
                }
            }
        }
        
        let delegate = TableViewBlockDelegate(tableView: self.tableView!, itemSelectionBlock: itemSelectionBlock, loadMoreDataBlock: nil)
        
        delegate.heightForHeaderInSectionBlock = { (section: Int) -> CGFloat in
            return 24
        }
        
        delegate.viewForHeaderInSectionBlock = { (section: Int) -> UIView? in
            return self.resultHeader
        }
        
        return delegate
    }
    
    
    // MARK: - Keyboard Notifications
    
    func registerForKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWasShown:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillBeHidden:"), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func deregisterFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWasShown(notification: NSNotification) {
        UIView.animateWithDuration(0.3) { () -> Void in
            self.containerView.frame.origin.y = 35
        }
    }
    
    func keyboardWillBeHidden(notification: NSNotification) {
        UIView.animateWithDuration(0.3) { () -> Void in
            self.containerView.frame.origin.y = 126
        }
    }
    
    
    // MARK: - Actions
    
    @IBAction func leftBarButtonAction(sender: UIBarButtonItem) {
        
        if self.status == .Searching {
            self.status = .Normal;
            self.updateSearchBarForStatus(self.status)
        }
        
    }
    
    @IBAction func rightBarButtonAction(sender: UIBarButtonItem) {
        if self.status == .Normal {
            self.status = .Searching
        } else if self.status == .Searching {
            self.status = .Normal
        }
        
        self.updateSearchBarForStatus(self.status)
    }
    
    
    private func updateSearchBarForStatus(status: SearchBarStatus) {
        switch status {
        case .Normal:
            self.leftBarButtonItem.image = UIImage(named: "ic_menu_white")
            self.rightBarButtonItem.image = UIImage(named: "ic_search_white")
            self.searchTextField.hidden = true
            self.searchTextField.resignFirstResponder()
        case .Searching:
            self.leftBarButtonItem.image = UIImage(named: "ic_arrow_back_white")
            self.rightBarButtonItem.image = UIImage(named: "ic_close_white")
            self.searchTextField.hidden = false
            self.searchTextField.becomeFirstResponder()
        }
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if let movieName = textField.text {
            self.searchMovies(movieName)
        }
        textField.resignFirstResponder()
        return true
    }
    
    func refreshData(totalResults: Int) {
        if let dataSource = self.dataSource as? FetcherDataSource<MovieListTableViewCell, OmdbMovie> {
            dataSource.refreshData()
            self.tableView!.reloadData()
            
            // count results
            if totalResults > 0 {
                self.searchInfoView.hidden = true
                self.resultHeader.sectionTitle.text = "Encontramos \(totalResults) resultados:"
            }
        }
    }
    
    func searchMovies(title: String) {
        
        OmdbApiClient(appContext: self.appContext).searchMovie(title, atPage: 0, completionBlock: { (totalResults: Int, movies:[OmdbMovie]?) -> Void in
            self.refreshData(totalResults)
        }) { (error: NSError) -> Void in
            self.appContext.logger.logError(error)
        }
        
    }
    
    func searchMovie(title: String) {
        
        OmdbApiClient(appContext: self.appContext).fetchMovie(title,completionBlock: { (movie:OmdbMovie?) -> Void in
            if let movie = movie {
                let imdbId = movie.imdbID ?? ""
                let route = Routes().showMovieUrl(imdbId)
                self.appContext.router.navigateInternal(route)
            }
        }) { (error: NSError) -> Void in
            self.appContext.logger.logError(error)
        }
    }
}
