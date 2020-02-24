//
//  DetailViewModel.swift
//  NewsFeed
//
//  Created by yana mulyana on 19/02/20.
//  Copyright © 2020 LinkAJa. All rights reserved.
//

import Foundation

protocol DetailViewModelDelegate {
    func success()
}

class DetailViewModel {
    
    var detailViewModelDelegate: DetailViewModelDelegate?
    var persistent: PersistentManager
    var page = 0
    var contents: Contents?
    var contentFeed: Contents?
    var article: Article?
    
    init(persistent: PersistentManager, contents: Contents?, page: Int) {
        self.persistent = persistent
        self.contents = contents
        self.page = page
    }
    
    func saveFeedFavorite() {
        let fav = Favorite(context: self.persistent.context)
        fav.main = article?.headline?.main
        fav.snippet = article?.snippet
        if let multimedia = article?.multimedia, multimedia.count > 0 {
            fav.url = multimedia[0].url
        }
        
        self.persistent.save()
        self.detailViewModelDelegate?.success()
    }
    
}
