//
//  LocationManager.swift
//  HookahPlaces
//
//  Created by Евгений on 11/11/2018.
//  Copyright © 2018 Momotov. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static let sharedInstance = LocationManager()
    
    var manager = CLLocationManager()
    
    func requestAuth() {
        manager.requestWhenInUseAuthorization()
    }
    
    var currentLocation: CLLocation? {
        didSet {
            if currentLocation != nil {
                NotificationCenter.default.post(name: NSNotification.Name("GetCurrentLocation"), object: nil)
            }
        }
    }
    
    func startUpdateLocation() {
        guard CLLocationManager.authorizationStatus() == .authorizedWhenInUse else {
            return
        }
        manager.delegate = self
        manager.activityType = .other
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            currentLocation = location
            manager.stopUpdatingLocation()
        }
    }
    
    func distanceToPlace(from currentLocation: CLLocation, to place: Place) -> Double {
        let placeLocation = CLLocation(latitude: place.latitude, longitude: place.longitude)
        let distance = currentLocation.distance(from: placeLocation)
        var doubleDistance = (Double(distance / 1000))
        doubleDistance = Double(round(10 * doubleDistance) / 10)
        return doubleDistance
    }
    
}
