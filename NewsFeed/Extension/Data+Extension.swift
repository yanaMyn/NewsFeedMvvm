//
//  Data+Extension.swift
//  NewsFeed
//
//  Created by yana mulyana on 11/02/20.
//  Copyright © 2020 LinkAJa. All rights reserved.
//

import Foundation

extension Data {
    func decode<T: Decodable>(modelType: T.Type, data: Data) -> Any? {
        do {
            let object = try JSONDecoder().decode(modelType, from: data)
            return object
        } catch let err {
            print(err.localizedDescription)
            return err
        }
    }
    
    var JSON: NSString? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }

        return prettyPrintedString
        //print(str!.data(using: .utf8)!.JSON!)
    }
}
