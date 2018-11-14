//
//  Model.swift
//  HookahPlaces
//
//  Created by Евгений on 29/10/2018.
//  Copyright © 2018 Momotov. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

class Model: NSObject {

    static let sharedInstance = Model()
    
    let databaseRef = Database.database().reference()
    let storageRef = Storage.storage().reference()
    
    var isAuth: Bool {
        if Auth.auth().currentUser == nil {
            return false
        }
        else {
            return true
        }
    }
    
    var idCurrentPlace: Int16? {
        get {
            if let id = UserDefaults.standard.string(forKey: "idPlace") {
                return Int16(id)
            }
            return nil
        }
        set {
            if newValue == nil {
                UserDefaults.standard.set(nil, forKey: "idPlace")
            }
            else {
                UserDefaults.standard.set("\(newValue!)", forKey: "idPlace")
            }
        }
    }
    
    func loadData() {
        for index in 0...15 {
            self.loadPlace(with: index)
        }
    }
    
    func loadPlace(with id: Int) {
        databaseRef.child("places/\(id)").observeSingleEvent(of: .value) { (snapshot) in
            let object = snapshot.value as? NSDictionary
            let id = object?["id"] as? Int16 ?? -1
            let name = object?["name"] as? String ?? ""
            let metro = object?["metroStation"] as? String ?? ""
            let address = object?["address"] as? String ?? ""
            let rating = object?["rating"] as? Double ?? 0
            let longitude = object?["longitude"] as? Double ?? 0
            let latitude = object?["latitude"] as? Double ?? 0
            let place = Place.newPlace(id: id, name: name, metro: metro, address: address, rating: rating, latitude: latitude, longitude: longitude)
            self.storageRef.child("places/\(id)-1.jpg").getData(maxSize: 1 * 1024 * 1024, completion: { (data, error) in
                guard error == nil else {
                    print("ERROR LOAD IMAGE")
                    return
                }
                place.image = data as NSData?
                NotificationCenter.default.post(name: NSNotification.Name("ReloadPlaces"), object: nil)
                CoreDataManager.sharedInstance.saveContext()
            })
            NotificationCenter.default.post(name: NSNotification.Name("ReloadPlaces"), object: nil)
            CoreDataManager.sharedInstance.saveContext()
        }
    }
    
    func getUserData(handler: (() -> Void)?) {
        let email = Auth.auth().currentUser!.email!
        UserDefaults.standard.set(email, forKey: "emailUser")
        databaseRef.child("users/\(Auth.auth().currentUser!.uid)").observeSingleEvent(of: .value) { (snapshot) in
            let data = snapshot.value as? NSDictionary
            let assesments = data?["countAssessment"] as? Int ?? 0
            let countPlaces = data?["countPlace"] as? Int ?? 0
            let name = data?["name"] as? String ?? ""
            if data?["isPlace"] as? Bool ?? false {
                if let id = data?["idPlace"] as? Int16 {
                    self.idCurrentPlace = id
                }
            }
            UserDefaults.standard.set(assesments, forKey: "countAssessments")
            UserDefaults.standard.set(countPlaces, forKey: "countPlaces")
            UserDefaults.standard.set(name, forKey: "nameUser")
            handler?()
        }
    }
    
    func newUser(to idPlace: Int16, with value: Int) {
        databaseRef.child("users/\(Auth.auth().currentUser!.uid)/isPlace").setValue(true)
        databaseRef.child("users/\(Auth.auth().currentUser!.uid)/countPlace").setValue(value)
        databaseRef.child("users/\(Auth.auth().currentUser!.uid)/idPlace").setValue(idPlace)
    }
    
    func exitUserFromPlace() {
        databaseRef.child("users/\(Auth.auth().currentUser!.uid)/isPlace").setValue(false)
        databaseRef.child("users/\(Auth.auth().currentUser!.uid)/idPlace").setValue(nil)
        idCurrentPlace = nil
    }
    
    func signOutUser() {
        if let _ = try? Auth.auth().signOut() {
            UserDefaults.standard.set(nil, forKey: "countAssessments")
            UserDefaults.standard.set(nil, forKey: "countPlaces")
            UserDefaults.standard.set(nil, forKey: "nameUser")
            UserDefaults.standard.set(nil, forKey: "emailUser")
            idCurrentPlace = nil
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initial = storyboard.instantiateInitialViewController()
            UIApplication.shared.keyWindow?.rootViewController = initial
        }
    }
    
}
