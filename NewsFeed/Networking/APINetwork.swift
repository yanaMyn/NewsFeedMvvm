//
//  APINetwork.swift
//  NewsFeed
//
//  Created by yana mulyana on 19/02/20.
//  Copyright © 2020 LinkAJa. All rights reserved.
//

import Foundation

public class APINetwork: DefaultRequest {
    
    fileprivate var sessionValue: URLSession = URLSession(configuration: .default)
    fileprivate var dataTaskValue: URLSessionDataTask?
    fileprivate var resumeDataValue: Data = Data()
    fileprivate var downloadTaskValue: URLSessionDownloadTask?
    fileprivate var requestValue: NSMutableURLRequest?
    
    public var session: URLSession {
        get {
            return self.sessionValue
        }
        set {
            self.sessionValue = newValue
        }
    }
    
    public var request: NSMutableURLRequest? {
        get {
            if let requestValue = self.requestValue {
                return requestValue
            }
            self.requestValue = NSMutableURLRequest()
            return self.requestValue
        }
        set {
            self.requestValue = newValue
        }
    }
    
    public var dataTask: URLSessionDataTask? {
        get {
            guard let dataTaskValue = self.dataTaskValue else { return nil }
            return dataTaskValue
        }
        set {
            self.dataTaskValue = newValue
        }
    }
    
    public init(configuration: URLSessionConfiguration = URLSessionConfiguration.default) {
        self.session = URLSession(configuration: configuration)
    }
    
    public init(configuration: URLSessionConfiguration = URLSessionConfiguration.default, delegate: URLSessionDelegate, queue: OperationQueue? = nil) {
        self.session = URLSession(configuration: configuration, delegate: delegate, delegateQueue: queue)
    }
    
    public func encoding(urlString: String, aUrl: URL ,encoding: JSONEncoding, parameters: Parameters?) {
        switch encoding {
        case .default:
            self.request?.url = aUrl
            if let parameters = parameters {
                let httpBody = try? JSONSerialization.data(withJSONObject: parameters as Any, options: [])
                request?.httpBody = httpBody
                return
            }
            request?.httpBody = nil
        case .queryString:
            guard let parameters = parameters else {
                self.request?.url = aUrl
                return
            }
            
            let urlComponents = NSURLComponents(string: urlString)
            let aDict: [String: String] = parameters as! [String : String]
            urlComponents?.queryItems = aDict.map { (key, value) in
                URLQueryItem(name: key, value: value)
            }
            
            self.request?.url = urlComponents?.url
        }
    }
}

extension APINetwork: Request {
    public func performRequest(apiNetwork: APIWrapperHome, completionHandler: @escaping CompletionHandler) {
        guard let aUrl = URL(string: apiNetwork.endPoint) else { return }
        self.encoding(urlString: apiNetwork.endPoint, aUrl: aUrl, encoding: apiNetwork.encoding, parameters: apiNetwork.parameters)
        self.request?.httpMethod = apiNetwork.method.rawValue
        self.request?.allHTTPHeaderFields = apiNetwork.headers
        
        guard let request = self.request else { return }
        self.dataTask = self.session.dataTask(with: request as URLRequest, completionHandler: { (result) in
            completionHandler(result)
        })
        
        self.dataTask?.resume()
    }
    
    public func cancelRequest() {
        self.dataTask?.cancel()
    }
    
}
