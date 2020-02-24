//
//  DetailViewController.swift
//  NewsFeed
//
//  Created by yana mulyana on 19/02/20.
//  Copyright © 2020 LinkAJa. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var mainLbl: UILabel!
    
    var viewModel: DetailViewModel?
    
    fileprivate var favButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setupData()
        self.viewModel?.detailViewModelDelegate = self
    }
    
    func setupData() {
        guard let docs = self.viewModel?.contents?.docs else { return }
        for (index, obj) in docs.enumerated() {
            if index == self.viewModel?.page {
                if let img = obj.multimedia, img.count > 0 {
                    self.bannerImage.setImage(urlString: img[0].url)
                }
                self.titleLbl.text = obj.snippet
                self.mainLbl.text = obj.headline?.main
                self.viewModel?.article = obj
            }
        }
    }
    
    func setupView() {
        self.view.addGestureRecognizer(self.setupLeftSwipe())
        self.view.addGestureRecognizer(self.setupRightSwipe())
        
        self.setupButtonfav()
    }
    
    func setupButtonfav() {
        self.favButton = UIBarButtonItem(title: "Add Favorit", style: .plain, target: self, action: #selector(favTapped))
        self.favButton.tintColor = .black
        self.navigationItem.rightBarButtonItem = self.favButton
    }
    
    @objc func favTapped() {
        self.viewModel?.saveFeedFavorite()
    }
    
    func setupLeftSwipe() -> UISwipeGestureRecognizer {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        swipe.direction = .left
        
        return swipe
    }
    
    func setupRightSwipe() -> UISwipeGestureRecognizer {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        swipe.direction = .right
        
        return swipe
    }
    
    @objc func handleSwipes(_ sender: UISwipeGestureRecognizer) {
        if (sender.direction == .left) {
            self.viewModel?.page += 1
            self.setupData()
        }
        
        if (sender.direction == .right) {
            self.viewModel?.page -= 1
            self.setupData()
        }
        
    }
    
}

extension DetailViewController: DetailViewModelDelegate {
    func success() {
        let alert = UIAlertController(title: "Message", message: "Success Add to Favorite", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Oke", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
