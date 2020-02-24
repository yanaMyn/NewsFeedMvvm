//
//  Feed.swift
//  NewsFeed
//
//  Created by yana mulyana on 19/02/20.
//  Copyright © 2020 LinkAJa. All rights reserved.
//

import Foundation


import Foundation

struct Feed: Codable {
    let status: String
    let copyright: String
    let response: Contents?
}

struct Meta: Codable {
    let hits: Int
    let offset: Int
    let time: Int
}

struct Contents: Codable {
    var docs: [Article]?
    let meta: Meta?
    
    init(docs: [Article], meta: Meta?) {
        self.docs = docs
        self.meta = meta
    }
}

struct Article: Codable {
    let snippet: String
    var multimedia: [Multimedia]?
    var headline: Headline?

    init(snippet: String, url: String, desc: String) {
        self.snippet = snippet
        self.multimedia = []
        self.multimedia?.append(Multimedia(url: url))
        self.headline = Headline(main: desc)
    }

    private enum CodingKeys: String, CodingKey {
        case snippet
        case multimedia, headline
    }
}

struct Multimedia: Codable {
    var url: String

    init(url: String) {
        self.url = url
    }
}

struct Headline: Codable {
    var main: String

    init(main: String) {
        self.main = main
    }
}
