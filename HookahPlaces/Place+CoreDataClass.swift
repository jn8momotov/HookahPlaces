//
//  Place+CoreDataClass.swift
//  HookahPlaces
//
//  Created by Евгений on 29/10/2018.
//  Copyright © 2018 Momotov. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Place)
public class Place: NSManagedObject {
    
    class func newPlace(id: Int16, name: String, metro: String, address: String, rating: Double, latitude: Double, longitude: Double) -> Place {
        let place = Place(context: CoreDataManager.sharedInstance.managedObjectContext)
        place.id = id
        place.name = name
        place.metro = metro
        place.address = address
        place.rating = rating
        place.latitude = latitude
        place.longitude = longitude
        place.isLike = false
        place.distance = 0
        return place
    }
    
}
