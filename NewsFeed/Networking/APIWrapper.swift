//
//  APIWrapper.swift
//  NewsFeed
//
//  Created by yana mulyana on 10/02/20.
//  Copyright © 2020 LinkAJa. All rights reserved.
//

import Foundation

public enum Environment {
    case development, staging, production
}

public protocol APIWrapper {
    var baseUrl: String { get }
    var svc: String { get }
    var endPoint: String { get }
    var version: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: Parameters? { get }
    var headers: Headers? { get }
    var encoding: JSONEncoding { get }
}



