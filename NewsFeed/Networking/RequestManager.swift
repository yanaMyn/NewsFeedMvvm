//
//  RequestManager.swift
//  NewsFeed
//
//  Created by yana mulyana on 19/02/20.
//  Copyright © 2020 LinkAJa. All rights reserved.
//

import Foundation

public protocol DefaultRequest {
    var session: URLSession { get set }
    var request: NSMutableURLRequest? { get set }
    var dataTask: URLSessionDataTask? { get set }
    
    func encoding(urlString: String, aUrl: URL ,encoding: JSONEncoding, parameters: Parameters?)
}

public protocol Request {
    func performRequest(apiNetwork: APIWrapperHome, completionHandler: @escaping CompletionHandler)
    func cancelRequest()
}
