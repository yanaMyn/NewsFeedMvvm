//
//  HomeViewController.swift
//  NewsFeed
//
//  Created by yana mulyana on 19/02/20.
//  Copyright © 2020 LinkAJa. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var containerSearch: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    let refreshControl = UIRefreshControl()
    
    var viewModel: HomeViewModel = HomeViewModel(persistent: PersistentManager.shared)
    
    var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.dimsBackgroundDuringPresentation = false
        controller.hidesNavigationBarDuringPresentation = false
        controller.searchBar.sizeToFit()
        
        return controller
    }()
    
    fileprivate var favButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.viewModel.homeViewModelDelegate = self
        self.viewModel.fetchData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    func setupButtonfav() {
        self.favButton = UIBarButtonItem(title: "Favorit", style: .plain, target: self, action: #selector(favTapped))
        self.favButton.tintColor = .black
        self.navigationItem.rightBarButtonItem = self.favButton
    }
    
    @objc func favTapped() {
        let parentDetail = getControllerBy(id: "FavoriteViewController", fromStoryboardId: "Main") as! FavoriteViewController
        parentDetail.viewModel = FavoriteViewModel(persistent: PersistentManager.shared)
        self.navigationController?.pushViewController(parentDetail, animated: true)
    }
    
    func setupView() {
        self.title = "News Feed"
        self.collectionView.register(UINib(nibName:"HomeCollectionView", bundle: nil), forCellWithReuseIdentifier: HomeCollectionViewCell.identifier)
        self.collectionView.register(UINib(nibName:"HomeCollectionViewGrid", bundle: nil), forCellWithReuseIdentifier: HomeGridCollectionViewCell.identifier)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.refreshControl.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.refreshControl = refreshControl
        
        self.containerSearch.addSubview(searchController.searchBar)
        self.searchController.searchResultsUpdater = self
        
        self.setupButtonfav()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.orientation.isLandscape {
            self.viewModel.isGrid = true
        } else {
            self.viewModel.isGrid = false
        }

        self.collectionView.reloadData()
    }
    
    @objc private func didPullToRefresh(_ sender: Any) {
        self.viewModel.fetchData()
    }
    
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (self.searchController.isActive) {
            guard let feed  = self.viewModel.filteredContents?.docs else {
                return 0
            }
            return feed.count
        } else {
            guard let feed  = self.viewModel.contents?.docs else {
                return 0
            }
            return feed.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        var feed: [Article] = []
        var article: Article
        if (self.searchController.isActive) {
            feed = self.viewModel.filteredContents?.docs ?? []
            article = feed[indexPath.row]
        }
        else {
            feed = self.viewModel.contents?.docs ?? []
            article = feed[indexPath.row]
        }
        
        switch self.viewModel.isGrid {
        case true:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeGridCollectionViewCell.identifier, for: indexPath) as! HomeGridCollectionViewCell
            cell.lblArticle.text = article.snippet
            if let img = article.multimedia, img.count > 0 {
                cell.imgArticle.setImage(urlString: img[0].url)
            }

            return cell
        case false:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as! HomeCollectionViewCell
            cell.btnDelete.isHidden = true
            cell.lblArticle.text = article.snippet
            if let img = article.multimedia, img.count > 0 {
                cell.imgArticle.setImage(urlString: img[0].url)
            }

            return cell
        }

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         switch viewModel.isGrid {
            case true:
                return CGSize(width: collectionView.frame.width/4-20, height: 179)
            case false:
                return CGSize(width: collectionView.frame.width, height: 92)
        }
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let feed = self.viewModel.contents?.docs else {
            return
        }

        if indexPath.row + 1 == feed.count {
            self.viewModel.page += 1
            self.viewModel.fetchData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let parentDetail = getControllerBy(id: "DetailViewController", fromStoryboardId: "Main") as! DetailViewController
        parentDetail.viewModel = DetailViewModel(persistent: PersistentManager.shared, contents: self.viewModel.contents, page: indexPath.row)
        self.navigationController?.pushViewController(parentDetail, animated: true)
    }

}

extension HomeViewController: HomeViewModelDelegate {
    func success() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()

            self.refreshControl.endRefreshing()
            self.collectionView.invalidateIntrinsicContentSize()
        }
    }
    
    func failed(error: String) {
        print("failed \(error)")
        refreshControl.endRefreshing()
    }
    
    
}

extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        self.viewModel.filteredContents?.docs?.removeAll(keepingCapacity: false)
        self.viewModel.filteredContents = nil
        
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        
        let filtered = self.viewModel.contents?.docs?.filter {
            searchPredicate.evaluate(with: $0.snippet)
        }
        
        if let filtered = filtered, filtered.count > 0 {
            self.viewModel.filteredContents = Contents(docs: filtered, meta: self.viewModel.contents!.meta)
            self.collectionView.reloadData()
        }
        
    }
}
