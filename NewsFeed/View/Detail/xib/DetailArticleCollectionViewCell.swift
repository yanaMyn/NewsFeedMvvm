//
//  DetailArticleCollectionViewCell.swift
//  NewsFeed
//
//  Created by yana mulyana on 19/02/20.
//  Copyright © 2020 LinkAJa. All rights reserved.
//

import UIKit

class DetailArticleCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var mainLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

extension DetailArticleCollectionViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}
