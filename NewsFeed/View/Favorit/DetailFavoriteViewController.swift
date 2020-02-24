//
//  DetailFavoriteViewController.swift
//  NewsFeed
//
//  Created by yana mulyana on 19/02/20.
//  Copyright © 2020 LinkAJa. All rights reserved.
//

import UIKit

class DetailFavoriteViewController: UIViewController {

    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var mainLbl: UILabel!
    
    var viewModel: DetailFavoriteViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupData()
        // Do any additional setup after loading the view.
    }
    
    func setupData() {
        guard let article = self.viewModel?.article else { return }
        if let img = article.multimedia, img.count > 0 {
            self.bannerImage.setImage(urlString: img[0].url)
        }
        self.titleLbl.text = article.snippet
        self.mainLbl.text = article.headline?.main
        
    }

}
