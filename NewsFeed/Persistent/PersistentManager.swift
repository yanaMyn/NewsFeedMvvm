//
//  SessionManagerDelegate.swift
//  NewsFeed
//
//  Created by yana mulyana on 19/02/20.
//  Copyright © 2020 LinkAJa. All rights reserved.
//

import Foundation
import CoreData

protocol Persistent {
    var context: NSManagedObjectContext { get }
    var persistentContainer: NSPersistentContainer { get set }
    
    func save()
    func fetch<T: NSManagedObject>(objectType: T.Type) -> [T]
    func delete(object: NSManagedObject)
}

public class PersistentManager: Persistent {
    static var shared = PersistentManager()
    lazy var context = persistentContainer.viewContext
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ContentsFeed")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    private init() {}
    
    func save() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch let error as NSError {
            print("Persistent Error: \(error), \(error.userInfo)")
        }
    }
    
    func fetch<T: NSManagedObject>(objectType: T.Type) -> [T] {
        let entityName = String(describing: objectType)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        do {
            let fetchedObjects = try context.fetch(fetchRequest) as? [T]
            return fetchedObjects ?? [T]()
        } catch {
            print(error)
            return [T]()
        }
    }
    
    func delete(object: NSManagedObject) {
        context.delete(object)
        save()
    }
    
}
