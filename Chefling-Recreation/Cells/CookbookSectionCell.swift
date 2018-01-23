//
//  CookbookSectionCell.swift
//  Chefling-Recreation
//
//  Created by Sayantan Chakraborty on 23/01/18.
//  Copyright © 2018 Sayantan Chakraborty. All rights reserved.
//

import UIKit

class CookbookSectionCell: UITableViewCell {

    @IBOutlet weak var sectionDetailsCollectionView: UICollectionView!
    @IBOutlet weak var sectionHeaderText: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension CookbookSectionCell {
    
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {
        
        sectionDetailsCollectionView.delegate = dataSourceDelegate
        sectionDetailsCollectionView.dataSource = dataSourceDelegate
        sectionDetailsCollectionView.tag = row
        sectionDetailsCollectionView.setContentOffset(sectionDetailsCollectionView.contentOffset, animated:false) // Stops collection view if it was scrolling.
        sectionDetailsCollectionView.reloadData()
    }
    
    var collectionViewOffset: CGFloat {
        set { sectionDetailsCollectionView.contentOffset.x = newValue }
        get { return sectionDetailsCollectionView.contentOffset.x }
    }
}
