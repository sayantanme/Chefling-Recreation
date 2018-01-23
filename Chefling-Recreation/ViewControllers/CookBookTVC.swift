//
//  CookBookTVC.swift
//  Chefling-Recreation
//
//  Created by Sayantan Chakraborty on 23/01/18.
//  Copyright © 2018 Sayantan Chakraborty. All rights reserved.
//

import UIKit

class CookBookTVC: UITableViewController {

    
    @IBOutlet var searchitem: UIBarButtonItem!
    let model: [[UIColor]] = generateRandomData()
    var storedOffsets = [Int: CGFloat]()
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        navigationItem.rightBarButtonItem = nil
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
        return model.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "collectionCells", for: indexPath)

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > -80 {
            if navigationItem.rightBarButtonItem == nil {
                navigationItem.rightBarButtonItem = searchitem
            }
        }else{
            navigationItem.rightBarButtonItem = nil
        }
    }

}


extension CookBookTVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        return model[collectionView.tag].count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collCell",
                                                      for: indexPath) as! ReceipeCollectionViewCell
        
        cell.dropShadow()
        cell.containerView.backgroundColor = model[collectionView.tag][indexPath.item]
        cell.containerView.layer.masksToBounds = true
        cell.containerView.layer.cornerRadius = 10
        cell.backgroundColor = model[collectionView.tag][indexPath.item]
        
        return cell
    }
}
