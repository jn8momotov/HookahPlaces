//
//  LoginCell.swift
//  HookahPlaces
//
//  Created by Евгений on 02/11/2018.
//  Copyright © 2018 Momotov. All rights reserved.
//

import UIKit

class LoginCell: UITableViewCell {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    func initCell() {
        loginButton.layer.cornerRadius = 5
        loginButton.clipsToBounds = true
        signupButton.layer.cornerRadius = 5
        signupButton.clipsToBounds = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
