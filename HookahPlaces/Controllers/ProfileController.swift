//
//  ProfileController.swift
//  HookahPlaces
//
//  Created by Евгений on 02/11/2018.
//  Copyright © 2018 Momotov. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileController: UITableViewController {
    
    var currentPlace: Place? {
        if let id = Model.sharedInstance.idCurrentPlace {
            return CoreDataManager.sharedInstance.getPlace(with: id)
        }
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "ReloadTableView"), object: nil, queue: nil) { (notification) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        
    }
    
    @IBAction func refreshControlAction(_ sender: Any) {
        self.refreshControl!.endRefreshing()
        Model.sharedInstance.getUserData {
            self.tableView.reloadData()
        }
    }
    
    @IBAction func exitFromPlaceButtonPressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Уйти?", message: "Вы действительно хотите покинуть \(currentPlace!.name!) \(currentPlace!.metro!)?", preferredStyle: .alert)
        alertController.view.tintColor = UIColor.black
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        let doneAction = UIAlertAction(title: "Уйти", style: .default) { (action) in
            Model.sharedInstance.exitUserFromPlace()
            self.tableView.reloadData()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(doneAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Model.sharedInstance.isAuth, Model.sharedInstance.idCurrentPlace != nil {
            return 3
        }
        return 2
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 150
        case 1:
            if Model.sharedInstance.isAuth {
                return 135
            }
            return 120
        case 2:
            return 140
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "imageUserCell", for: indexPath) as! ImageUserCell
            if Model.sharedInstance.isAuth {
                cell.initCell(for: Auth.auth().currentUser!.uid)
            }
            return cell
        case 1:
            if Model.sharedInstance.isAuth {
                let cell = tableView.dequeueReusableCell(withIdentifier: "infoUserCell", for: indexPath) as! InfoUserCell
                cell.initCell()
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "loginCell", for: indexPath) as! LoginCell
            cell.initCell()
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "currentPlaceCell", for: indexPath) as! CurrentPlaceCell
            cell.initCell(for: currentPlace)
            return cell
        default:
            return UITableViewCell()
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "segueToDetail":
            let controller = segue.destination as! DetailPlaceController
            controller.place = currentPlace
        default:
            return
        }
    }

}
