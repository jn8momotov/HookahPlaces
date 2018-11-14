//
//  MapController.swift
//  HookahPlaces
//
//  Created by Евгений on 11/11/2018.
//  Copyright © 2018 Momotov. All rights reserved.
//

import UIKit
import MapKit

class PlaceAnnotation: MKPointAnnotation {
    var tag: Int16?
}

class MapController: UIViewController {
    
    var place: Place?

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var placeView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var namePlaceLabel: UILabel!
    @IBOutlet weak var addressPlaceLabel: UILabel!
    @IBOutlet weak var addNewUserButton: UIButton!
    @IBOutlet weak var countUsersPlaceButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationManager.sharedInstance.startUpdateLocation()
        mapView.delegate = self
        mapView.showsUserLocation = true
        initViews()
        if let place = place {
            addAnnotation(for: place)
            let zoomRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude), latitudinalMeters: 5000, longitudinalMeters: 5000)
            mapView.setRegion(zoomRegion, animated: true)
            return
        }
        for item in placesRating {
            addAnnotation(for: item)
        }
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "GetCurrentLocation"), object: nil, queue: nil) { (notification) in
            let coordinate = LocationManager.sharedInstance.currentLocation!.coordinate
            let zoomRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
            self.mapView.setRegion(zoomRegion, animated: true)
        }
    }
    
    @IBAction func countUsersPlaceButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func addNewUserButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func cancelBarButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func routeToPlaceBarButtonPressed(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Построить маршрут", message: nil, preferredStyle: .actionSheet)
        alertController.view.tintColor = UIColor.black
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        let yandexMapAction = UIAlertAction(title: "Yandex карты", style: .default) { (action) in
            
        }
        let googleMapAction = UIAlertAction(title: "Google карты", style: .default) { (action) in
            
        }
        alertController.addAction(cancelAction)
        alertController.addAction(yandexMapAction)
        alertController.addAction(googleMapAction)
        present(alertController, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func addAnnotation(for place: Place) {
        let annotation = PlaceAnnotation()
        annotation.tag = place.id
        annotation.coordinate = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
        annotation.title = place.name
        annotation.subtitle = place.metro
        mapView.addAnnotation(annotation)
    }
    
    func initViews() {
        placeView.alpha = 0
        placeView.layer.cornerRadius = 10
        placeView.layer.borderColor = UIColor.black.cgColor
        placeView.layer.borderWidth = 3
        placeView.clipsToBounds = true
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.clipsToBounds = true
        addNewUserButton.layer.cornerRadius = 5
        addNewUserButton.layer.borderWidth = 2
        addNewUserButton.layer.borderColor = UIColor.black.cgColor
        addNewUserButton.clipsToBounds = true
        countUsersPlaceButton.layer.cornerRadius = 5
        countUsersPlaceButton.layer.borderWidth = 2
        countUsersPlaceButton.layer.borderColor = UIColor.black.cgColor
        countUsersPlaceButton.clipsToBounds = true
    }

}

extension MapController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let coordinate = view.annotation!.coordinate
        let zoomRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
        self.mapView.setRegion(zoomRegion, animated: true)
        if let id = (view.annotation as? PlaceAnnotation)?.tag {
            place = CoreDataManager.sharedInstance.getPlace(with: id)
            namePlaceLabel.text = "\(place!.name!) \(place!.metro!)"
            if let image = place!.image {
                imageView.image = UIImage(data: image as Data)
            }
            addressPlaceLabel.text = place!.address
            placeView.alpha = 1
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        placeView.alpha = 0
    }
    
}
