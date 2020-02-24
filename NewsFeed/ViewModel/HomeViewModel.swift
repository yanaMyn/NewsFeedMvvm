//
//  HomeViewModel.swift
//  NewsFeed
//
//  Created by yana mulyana on 19/02/20.
//  Copyright © 2020 LinkAJa. All rights reserved.
//

import Foundation

protocol HomeViewModelDelegate {
    func success()
    func failed(error: String)
}

class HomeViewModel {
    
    var persistent: PersistentManager
    var homeViewModelDelegate: HomeViewModelDelegate?
    static let sessionManager = SessionManager()
    
    lazy var service: APINetwork = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        let newSession = APINetwork(configuration: configuration, delegate: HomeViewModel.sessionManager)
        return newSession
    }()
    
    var isGrid = false
    var feed: Feed?
    var contents: Contents?
    var filteredContents: Contents?
    var page: Int = 0
    
    init(persistent: PersistentManager) {
        self.persistent = persistent
    }
    
    func fetchData() {
        if Reachability.isConnectedToNetwork(){
            self.requestData()
        } else {
            self.contents = nil
            let contents = self.persistent.fetch(objectType: ContentsFeed.self)
            var articles: [Article] = []
            for obj in contents {
                let article = Article(snippet: obj.snippet ?? "", url: obj.url ?? "", desc: obj.main ?? "")
                articles.append(article)
            }
            let content = Contents(docs: articles, meta: nil)
            self.contents = content
            self.homeViewModelDelegate?.failed(error: "No internet")
        }
    }
    
    func requestData() {
        self.service.performRequest(apiNetwork: .getList(page: page, querySearch: "Indonesia")) { [weak self] (result) in
            switch result {
            case .success(let data, let urlResponse):
                
            guard let object = data.decode(modelType: Feed.self, data: data) as? Feed, urlResponse?.statusCode == 200 else { return }
            if let docs = self?.contents?.docs, docs.count > 0 {
                self?.contents?.docs! += (object.response?.docs)!
            } else {
                self?.contents = object.response
                
                let contents = self?.persistent.fetch(objectType: ContentsFeed.self)
                if let contents = contents, contents.count > 0 {
                    for obj in contents {
                        self?.persistent.delete(object: obj)
                    }
                }
                
                if let docs = object.response?.docs, docs.count > 0 {
                    for object in docs {
                        let feed = ContentsFeed(context: (self?.persistent.context)!)
                        feed.main = object.headline?.main
                        feed.snippet = object.snippet
                        if let multimedia = object.multimedia, multimedia.count > 0 {
                            feed.url = multimedia[0].url
                        }
                        
                        self?.persistent.save()
                    }
                }
                
            }
            
            self?.homeViewModelDelegate?.success()
            case .failure(let error):
                self?.homeViewModelDelegate?.failed(error: error.localizedDescription)
            }
        }
    }
    
}

class SessionManager: SessionManagerDelegate {
    override init() {
        super.init()

        sessionDidReceiveChallengeWithCompletion = { session, challenge, completion in
            guard let trust = challenge.protectionSpace.serverTrust, SecTrustGetCertificateCount(trust) > 0 else {
                completion(.cancelAuthenticationChallenge, nil)
                return
            }

            let host: String?
            host = challenge.protectionSpace.host
            
            if let host = host, host.hasPrefix("api.nytimes.com") {
                completion(URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust:challenge.protectionSpace.serverTrust!))
                return
            }
            
            completion(.cancelAuthenticationChallenge, nil)
        }

    }
}
