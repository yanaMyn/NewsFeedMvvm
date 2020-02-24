//
//  UIImageView+Extension.swift
//  NewsFeed
//
//  Created by yana mulyana on 19/02/20.
//  Copyright © 2020 LinkAJa. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, AnyObject>()

extension UIImageView {
    func setImage(urlString : String) {
        let url = URL(string: "https://www.nytimes.com/\(urlString)")
        self.image = nil
        
        // check cached image
        if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
            self.image = cachedImage
            return
        }
        
        // if not, download image from url
        guard let urlStr = url else { return }
        URLSession.shared.dataTask(with: urlStr, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            
            guard let data = data else { return }
            DispatchQueue.main.async {
                if let image = UIImage(data: data) {
                    imageCache.setObject(image, forKey: urlString as NSString)
                    self.image = image
                }
            }
            
        }).resume()
    }
}
