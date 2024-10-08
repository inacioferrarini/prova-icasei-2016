import UIKit

class BaseTableViewController: BaseDataBasedViewController {

    // MARK: - Properties
    
    var refreshControl:UIRefreshControl?
    @IBOutlet weak var tableView: UITableView?    
    
    var dataSource:UITableViewDataSource?
    var delegate:UITableViewDelegate?
    
    private var tableViewBGView:UIView?
    
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let tableView = self.tableView {
            self.setupTableView()
            self.tableViewBGView = tableView.backgroundView
            
            if let selfAsDataSource = self as? UITableViewDataSource {
                tableView.dataSource = selfAsDataSource
            } else {
                self.dataSource = self.createDataSource()
                tableView.dataSource = self.dataSource
            }
            
            if let selfAsDelegate = self as? UITableViewDelegate {
                tableView.delegate = selfAsDelegate
            } else {
                self.delegate = self.createDelegate()
                tableView.delegate = self.delegate
            }
            
            
            self.refreshControl = UIRefreshControl()
            if let refreshControl = self.refreshControl {
                refreshControl.backgroundColor = UIColor.blackColor()
                refreshControl.tintColor = UIColor.whiteColor()
                refreshControl.addTarget(self, action: Selector("performDataSync"), forControlEvents: .ValueChanged)

                tableView.addSubview(refreshControl)
                tableView.reloadData()
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.performDataSyncIfNeeded()
    }
    
    override func viewWillDisappear(animated: Bool) {

        if let tableView = self.tableView,
            let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRowAtIndexPath(selectedIndexPath, animated: true)
        }
        
        super.viewWillDisappear(animated)
    }
    
    
    // MARK: - Data Syncrhonization
    
    override func performDataSync() {
        dataSyncCompleted()
    }
    
    override func dataSyncCompleted() {
        if let refreshControl = self.refreshControl {
            refreshControl.endRefreshing()
        }
        super.dataSyncCompleted()
    }
    
    
    // MARK: - TableView Appearance
    
    func defaultEmptyResultsBackgroundView() -> UIView? {
        return tableViewBGView
    }
    
    func defaultNonEmptyResultsBackgroundView() -> UIView? {
        return tableViewBGView
    }
    

    // MARK: - Child classes are expected to override these methods
    
    func setupTableView() {}
    
    func createDataSource() -> UITableViewDataSource? { return nil }
    
    func createDelegate() -> UITableViewDelegate? { return nil }
    
}
