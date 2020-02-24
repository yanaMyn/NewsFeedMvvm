//
//  ContentsFeed+CoreDataProperties.swift
//  NewsFeed
//
//  Created by yana mulyana on 19/02/20.
//  Copyright © 2020 LinkAJa. All rights reserved.
//
//

import Foundation
import CoreData


extension ContentsFeed {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ContentsFeed> {
        return NSFetchRequest<ContentsFeed>(entityName: "ContentsFeed")
    }

    @NSManaged public var snippet: String?
    @NSManaged public var url: String?
    @NSManaged public var main: String?

}
