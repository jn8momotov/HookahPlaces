//
//  Place+CoreDataProperties.swift
//  HookahPlaces
//
//  Created by Евгений on 29/10/2018.
//  Copyright © 2018 Momotov. All rights reserved.
//
//

import Foundation
import CoreData


extension Place {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Place> {
        return NSFetchRequest<Place>(entityName: "Place")
    }

    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var metro: String?
    @NSManaged public var address: String?
    @NSManaged public var rating: Double
    @NSManaged public var distance: Double
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var image: NSData?
    @NSManaged public var isLike: Bool

}
