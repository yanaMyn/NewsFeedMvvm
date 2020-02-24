//
//  FavoriteViewModel.swift
//  NewsFeed
//
//  Created by yana mulyana on 19/02/20.
//  Copyright © 2020 LinkAJa. All rights reserved.
//

import Foundation

protocol FavoriteViewModelDelegate {
    func success()
    func failed(error: String)
}

class FavoriteViewModel {
    
    var persistent: PersistentManager
    var contents: Contents?
    
    var favoriteViewModelDelegate: FavoriteViewModelDelegate?
    
    init(persistent: PersistentManager) {
        self.persistent = persistent
    }
    
    func getData() {
        let contents = self.persistent.fetch(objectType: Favorite.self)
        var articles: [Article] = []
        for obj in contents {
            let article = Article(snippet: obj.snippet ?? "", url: obj.url ?? "", desc: obj.main ?? "")
            articles.append(article)
        }
        let content = Contents(docs: articles, meta: nil)
        self.contents = content
    }
    
}
