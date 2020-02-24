//
//  UIViewController+Extension.swift
//  NewsFeed
//
//  Created by yana mulyana on 19/02/20.
//  Copyright © 2020 LinkAJa. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func getControllerBy(id: String, fromStoryboardId: String = "Main") -> UIViewController {
        return UIStoryboard(name: fromStoryboardId, bundle: nil).instantiateViewController(withIdentifier: id)
    }

}
