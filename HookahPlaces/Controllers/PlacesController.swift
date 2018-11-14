//
//  PlacesController.swift
//  HookahPlaces
//
//  Created by Евгений on 02/11/2018.
//  Copyright © 2018 Momotov. All rights reserved.
//

import UIKit
import CoreData

enum TypeSorted {
    case rating
    case distance
}

class PlacesController: UITableViewController {
    
    var isSort: TypeSorted?
    
    var countRows: Int? {
        didSet {
            if isSort == TypeSorted.distance {
                if placesDistance.count - countRows! < 5 {
                    countRows = placesDistance.count
                }
            } else {
                if placesRating.count - countRows! < 5 {
                    countRows = placesRating.count
                }
            }
            self.tableView.reloadData()
        }
    }
    
    @IBOutlet weak var nameSortLabel: UILabel!
    @IBOutlet weak var rightControllerButton: UIButton!
    @IBOutlet weak var leftControllerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countRows = 10
        if placesRating.count == 0, placesDistance.count == 0 {
            Model.sharedInstance.loadData()
        }
        if isSort == TypeSorted.distance {
            nameSortLabel.text = "Рядом"
            rightControllerButton.alpha = 0
        } else {
            nameSortLabel.text = "Популярное"
            leftControllerButton.alpha = 0
        }
        configBackBarButtonItem()
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "ReloadPlaces"), object: nil, queue: nil) { (notification) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "GetCurrentLocation"), object: nil, queue: nil) { (notification) in
            DispatchQueue.main.async {
                for place in placesRating {
                    place.distance = LocationManager.sharedInstance.distanceToPlace(from: LocationManager.sharedInstance.currentLocation!, to: place)
                    self.tableView.reloadData()
                }
            }
        }
    }

    @IBAction func refreshControlAction(_ sender: Any) {
        LocationManager.sharedInstance.startUpdateLocation()
        refreshControl?.endRefreshing()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countRows!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "placeCell", for: indexPath) as! PlaceMainCell
        var place: Place?
        if isSort == TypeSorted.distance {
            place = placesDistance[indexPath.row]
        } else {
            place = placesRating[indexPath.row]
        }
        cell.initCell(with: place!)
        return cell
    }

    // MARK: - Navigation

     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         switch segue.identifier {
             case "toDetailPlace":
                 let controller = segue.destination as! DetailPlaceController
                 let selectedCell = sender as? PlaceMainCell
                 let index = (tableView.indexPath(for: selectedCell!)?.row)!
                 controller.place = isSort == TypeSorted.rating ? placesRating[index] : placesDistance[index]
             default:
                return
         }
     }

}
