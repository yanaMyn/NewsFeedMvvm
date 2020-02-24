//
//  SessionManagerDelegate.swift
//  NewsFeed
//
//  Created by yana mulyana on 19/02/20.
//  Copyright © 2020 LinkAJa. All rights reserved.
//

import Foundation

open class SessionManagerDelegate: NSObject {
    
    open var sessionDidReceiveChallengeWithCompletion: ((URLSession, URLAuthenticationChallenge, @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) -> Void)?
    
    public override init() {
        super.init()
    }
    
}

extension SessionManagerDelegate: URLSessionDelegate {
    
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        sessionDidReceiveChallengeWithCompletion?(session, challenge, completionHandler)
    }
    
}
