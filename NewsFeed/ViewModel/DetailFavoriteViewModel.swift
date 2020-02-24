//
//  DetailFavoriteViewModel.swift
//  NewsFeed
//
//  Created by yana mulyana on 19/02/20.
//  Copyright © 2020 LinkAJa. All rights reserved.
//

import Foundation

class DetailFavoriteViewModel {
    
    var persistent: PersistentManager
    var contents: Contents?
    let article: Article?
    
    init(persistent: PersistentManager, article: Article?) {
        self.persistent = persistent
        self.article = article
    }
    
}
