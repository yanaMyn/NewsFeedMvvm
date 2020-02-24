//
//  HomeGridCollectionViewCell.swift
//  NewsFeed
//
//  Created by yana mulyana on 10/02/20.
//  Copyright © 2020 LinkAJa. All rights reserved.
//

import UIKit

class HomeGridCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imgArticle: UIImageView!
    @IBOutlet weak var lblArticle: UILabel!
    
}

extension HomeGridCollectionViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}
