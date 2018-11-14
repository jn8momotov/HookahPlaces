//
//  ImageUserCell.swift
//  HookahPlaces
//
//  Created by Евгений on 02/11/2018.
//  Copyright © 2018 Momotov. All rights reserved.
//

import UIKit
import FirebaseUI

class ImageUserCell: UITableViewCell {
    
    @IBOutlet weak var imageUser: UIImageView!
    
    func initCell(for id: String?) {
        imageUser.layer.cornerRadius = imageUser.frame.height / 2
        imageUser.clipsToBounds = true
        if let id = id {
            let storageRef = Storage.storage().reference().child("users/\(id).png")
            imageUser.sd_setImage(with: storageRef, placeholderImage: UIImage(named: "user"))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
