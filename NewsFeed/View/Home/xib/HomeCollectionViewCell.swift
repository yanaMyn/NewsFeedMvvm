//
//  HomeCollectionViewCell.swift
//  NewsFeed
//
//  Created by yana mulyana on 10/02/20.
//  Copyright © 2020 LinkAJa. All rights reserved.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgArticle: UIImageView!
    @IBOutlet weak var lblArticle: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    
    
    @IBAction func btnDeleteTapped(_ sender: UIButton) {
        
    }
    
}

extension HomeCollectionViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}
