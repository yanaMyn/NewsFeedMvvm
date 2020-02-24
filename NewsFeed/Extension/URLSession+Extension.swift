//
//  URLSession+Extension.swift
//  NewsFeed
//
//  Created by yana mulyana on 10/02/20.
//  Copyright © 2020 LinkAJa. All rights reserved.
//

import Foundation

extension URLSession {
    
    func dataTask(with url: URLRequest, completionHandler: @escaping CompletionHandler) -> URLSessionDataTask {
        return dataTask(with: url, completionHandler: { (data, urlResponse, error) in
            if let error = error {
                completionHandler(.failure(error))
            } else if let data = data, let urlResponse = urlResponse as? HTTPURLResponse {
                completionHandler(.success((data, urlResponse)))
            }
        })
    }
    
}
