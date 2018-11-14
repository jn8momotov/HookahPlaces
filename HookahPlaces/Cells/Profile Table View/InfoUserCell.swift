//
//  InfoUserCell.swift
//  HookahPlaces
//
//  Created by Евгений on 02/11/2018.
//  Copyright © 2018 Momotov. All rights reserved.
//

import UIKit

class InfoUserCell: UITableViewCell {

    @IBOutlet weak var nameUserLabel: UILabel!
    @IBOutlet weak var emailUserLabel: UILabel!
    @IBOutlet weak var countPlacesLabel: UILabel!
    @IBOutlet weak var countAssessmentsLabel: UILabel!
    
    func initCell() {
        nameUserLabel.text = UserDefaults.standard.string(forKey: "nameUser")?.uppercased()
        emailUserLabel.text = UserDefaults.standard.string(forKey: "emailUser")
        countPlacesLabel.text = "\(UserDefaults.standard.integer(forKey: "countPlaces"))"
        countAssessmentsLabel.text = "\(UserDefaults.standard.integer(forKey: "countAssessments"))"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
