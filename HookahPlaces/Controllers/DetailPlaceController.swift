//
//  DetailPlaceController.swift
//  HookahPlaces
//
//  Created by Евгений on 03/11/2018.
//  Copyright © 2018 Momotov. All rights reserved.
//

import UIKit

class DetailPlaceController: UITableViewController {

    var place: Place?
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var imagePlace: UIImageView!
    @IBOutlet weak var namePlaceLabel: UILabel!
    @IBOutlet weak var addressPlaceLabel: UILabel!
    @IBOutlet weak var phonePlaceLabel: UILabel!
    @IBOutlet weak var ratingPlaceLabel: UILabel!
    @IBOutlet weak var hookahRatingProgressView: UIProgressView!
    @IBOutlet weak var staffRatingProgressView: UIProgressView!
    @IBOutlet weak var placeRatingProgressView: UIProgressView!
    
    @IBOutlet weak var likedPlaceBarButton: UIBarButtonItem!
    @IBOutlet weak var infoPlaceButton: UIButton!
    @IBOutlet weak var countUsersInPlaceButton: UIButton!
    @IBOutlet weak var callToPlaceButton: UIButton!
    @IBOutlet weak var showOnMapButton: UIButton!
    @IBOutlet weak var addAssessmentButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initPlace()
    }
    
    @IBAction func likedPlaceBarButtonPressed(_ sender: UIBarButtonItem) {
        if likedPlaceBarButton.tintColor == UIColor.black {
            likedPlaceBarButton.tintColor = UIColor.red
            place!.isLike = true
        }
        else {
            likedPlaceBarButton.tintColor = UIColor.black
            place!.isLike = false
        }
        CoreDataManager.sharedInstance.saveContext()
    }
    
    @IBAction func callToPlaceButtonPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func addNewUserBarButtonPressed(_ sender: UIBarButtonItem) {
        guard Model.sharedInstance.idCurrentPlace == nil else {
            showDefaultAlertController(title: "Упс..", message: "Вы уже находитесь в одном из заведений", handler: nil)
            return
        }
        let alertController = UIAlertController(title: "Новая отметка", message: "Вы действительно находитесь в \(place!.name!) \(place!.metro!)?", preferredStyle: .alert)
        alertController.view.tintColor = UIColor.black
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        let doneAction = UIAlertAction(title: "Подтверждаю", style: .default) { (action) in
            UserDefaults.standard.set("\(self.place!.id)", forKey: "idPlace")
            let newValue = UserDefaults.standard.integer(forKey: "countPlaces") + 1
            UserDefaults.standard.set(newValue, forKey: "countPlaces")
            Model.sharedInstance.newUser(to: self.place!.id, with: newValue)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReloadTableView"), object: self)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(doneAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func initPlace() {
        if let image = place!.image {
            imagePlace.image = UIImage(data: image as Data)
        }
        namePlaceLabel.text = "\(place!.name!) \(place!.metro!)"
        addressPlaceLabel.text = "\(place!.distance) км, \(place!.address!)"
        phonePlaceLabel.text = "Тел: +7 (499) 183-45-10"
        if place!.isLike {
            likedPlaceBarButton.tintColor = UIColor.red
        }
        else {
            likedPlaceBarButton.tintColor = UIColor.black
        }
        viewContainer.layer.cornerRadius = 10
        viewContainer.clipsToBounds = true
        callToPlaceButton.layer.cornerRadius = 5
        callToPlaceButton.layer.borderColor = UIColor.black.cgColor
        callToPlaceButton.layer.borderWidth = 2
        callToPlaceButton.clipsToBounds = true
        showOnMapButton.layer.cornerRadius = 5
        showOnMapButton.layer.borderColor = UIColor.black.cgColor
        showOnMapButton.layer.borderWidth = 2
        showOnMapButton.clipsToBounds = true
        countUsersInPlaceButton.layer.cornerRadius = 5
        countUsersInPlaceButton.layer.borderColor = UIColor.black.cgColor
        countUsersInPlaceButton.layer.borderWidth = 2
        countUsersInPlaceButton.clipsToBounds = true
        infoPlaceButton.layer.cornerRadius = 5
        infoPlaceButton.layer.borderColor = UIColor.black.cgColor
        infoPlaceButton.layer.borderWidth = 2
        infoPlaceButton.clipsToBounds = true
        addAssessmentButton.layer.cornerRadius = 5
        addAssessmentButton.layer.borderColor = UIColor.black.cgColor
        addAssessmentButton.layer.borderWidth = 2
        addAssessmentButton.clipsToBounds = true
        
        hookahRatingProgressView.transform = hookahRatingProgressView.transform.scaledBy(x: 1, y: 4)
        placeRatingProgressView.transform = placeRatingProgressView.transform.scaledBy(x: 1, y: 4)
        staffRatingProgressView.transform = staffRatingProgressView.transform.scaledBy(x: 1, y: 4)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "segueToMap":
            let navController = segue.destination as! UINavigationController
            let controller = navController.viewControllers[0] as! MapController
            controller.place = place
        default:
            return
        }
    }

}
