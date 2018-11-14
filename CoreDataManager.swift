//
//  CoreDataManager.swift
//  HookahPlaces
//
//  Created by Евгений on 29/10/2018.
//  Copyright © 2018 Momotov. All rights reserved.
//

import UIKit
import CoreData

var placesDistance: [Place] {
    let fetchRequest: NSFetchRequest<Place> = Place.fetchRequest()
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "distance", ascending: true)]
    let array = try? CoreDataManager.sharedInstance.managedObjectContext.fetch(fetchRequest)
    if array != nil {
        return array!
    }
    return []
}

var placesRating: [Place] {
    let fetchRequest: NSFetchRequest<Place> = Place.fetchRequest()
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "rating", ascending: false)]
    let array = try? CoreDataManager.sharedInstance.managedObjectContext.fetch(fetchRequest)
    if array != nil {
        return array!
    }
    return []
}

class CoreDataManager: NSObject {

    static let sharedInstance = CoreDataManager()
    
    var managedObjectContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "HookahPlaces")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func getPlace(with id: Int16) -> Place? {
        let fetchRequest: NSFetchRequest<Place> = Place.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = \(id)")
        return try? self.managedObjectContext.fetch(fetchRequest)[0]
    }

}
