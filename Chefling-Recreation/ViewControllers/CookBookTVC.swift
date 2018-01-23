//
//  CookBookTVC.swift
//  Chefling-Recreation
//
//  Created by Sayantan Chakraborty on 23/01/18.
//  Copyright © 2018 Sayantan Chakraborty. All rights reserved.
//

import UIKit

class CookBookTVC: UITableViewController,Notifier {

    
    @IBOutlet var searchitem: UIBarButtonItem!
    let model: [[UIColor]] = generateRandomData()
    var storedOffsets = [Int: CGFloat]()
    let searchController = UISearchController(searchResultsController: nil)
    var receipeGroups = [String]()
    var receipes: [String:[Receipe]] = [:]
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    var isConnectedToNetwork = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        navigationItem.rightBarButtonItem = nil
        
        navigationController?.view.addSubview(activityIndicator)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = (navigationController?.view.center)!
        activityIndicator.startAnimating()
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(self.fetchCookbooks), for: .valueChanged)
        self.refreshControl = refreshControl
        NotificationCenter.default.addObserver(self, selector: #selector(networkTypeChangedDashBoard), name: .networkChangedFlag, object: Network.reachability)
        
        fetchCookbooks()
    }
    
    @objc fileprivate func fetchCookbooks(){
        //checks if the app is connected to the network, then only makes the network call
        if isConnectedToNetwork{
            NetworkQueries().fetchCookbook { (receipes, error) in
                guard error.isEmpty else{
                    self.displayAlert(title: "Error", message: error)
                    return
                }
                if let rec = receipes{
                    self.receipes = rec
                    self.receipeGroups = Array((receipes?.keys)!)
                    self.tableView.reloadData()
                    self.activityIndicator.stopAnimating()
                }
                self.refreshControl?.endRefreshing()
            }
        }else{
            self.refreshControl?.endRefreshing()
            self.displayAlert(title: "Connectivity Issues", message: "Check your internet connection")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return receipeGroups.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "collectionCells", for: indexPath) as! CookbookSectionCell
        cell.sectionHeaderText.text = receipeGroups[indexPath.row]
        // Configure the cell...

        return cell
    }
    

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? CookbookSectionCell else { return }
        
        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
        tableViewCell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? CookbookSectionCell else { return }
        
        storedOffsets[indexPath.row] = tableViewCell.collectionViewOffset
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > -80 && scrollView.contentOffset.y != 0{
            if navigationItem.rightBarButtonItem == nil {
                navigationItem.rightBarButtonItem = searchitem
            }
        }else{
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    /// When network status chnages this will fire
    ///
    /// - Parameter notification: notification object
    @objc func networkTypeChangedDashBoard(_ notification: NSNotification) {
        guard let status = Network.reachability?.status else { return }
        switch status {
        case .unreachable:
            isConnectedToNetwork = false
        case .wifi:
            isConnectedToNetwork = true
        case .wwan:
            isConnectedToNetwork = true
        }
    }


}

///extension for the collection view inside each tableview cell
extension CookBookTVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        let key = receipeGroups[collectionView.tag]
        return self.receipes[key]!.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collCell",
                                                      for: indexPath) as! ReceipeCollectionViewCell
        
        
        let key = receipeGroups[collectionView.tag]
        let allReceipeForGroup = receipes[key]
        let rcpe = allReceipeForGroup![indexPath.row]
        
        cell.receipeLabel.text = rcpe.recipename
        cell.containerView.backgroundColor = model[collectionView.tag][indexPath.item]
        //cell.containerView.layer.masksToBounds = true
        cell.containerView.layer.cornerRadius = 10
        cell.imgReceipe.layer.masksToBounds = true
        cell.imgReceipe.layer.cornerRadius = 10
        cell.imgReceipe.loadImageFromImageUrlFromCache(url: rcpe.recipephoto!)
        
        cell.containerView.dropShadow()
        
        return cell
    }
}
