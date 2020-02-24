//
//  FavoriteViewController.swift
//  NewsFeed
//
//  Created by yana mulyana on 19/02/20.
//  Copyright © 2020 LinkAJa. All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var viewModel: FavoriteViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.viewModel?.getData()
    }

    func setupView() {
        self.collectionView.register(UINib(nibName:"HomeCollectionView", bundle: nil), forCellWithReuseIdentifier: HomeCollectionViewCell.identifier)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.alwaysBounceVertical = true
        self.viewModel?.favoriteViewModelDelegate = self
    }

}

extension FavoriteViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let feed  = self.viewModel?.contents?.docs else {
            return 0
        }
        return feed.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let feed: [Article] = self.viewModel?.contents?.docs ?? []
        var article: Article
        article = feed[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as! HomeCollectionViewCell
        cell.btnDelete.isHidden = true
        cell.lblArticle.text = article.snippet
        if let img = article.multimedia, img.count > 0 {
            cell.imgArticle.setImage(urlString: img[0].url)
        }

        return cell

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         return CGSize(width: collectionView.frame.width, height: 92)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let feed: [Article] = self.viewModel?.contents?.docs ?? []
        var article: Article
        article = feed[indexPath.row]
        
        let parentDetail = getControllerBy(id: "DetailFavoriteViewController", fromStoryboardId: "Main") as! DetailFavoriteViewController
        parentDetail.viewModel = DetailFavoriteViewModel(persistent: PersistentManager.shared, article: article)
        self.navigationController?.pushViewController(parentDetail, animated: true)
    }

}

extension FavoriteViewController: FavoriteViewModelDelegate {
    func success() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func failed(error: String) {
        print(error)
    }
    
    
}
