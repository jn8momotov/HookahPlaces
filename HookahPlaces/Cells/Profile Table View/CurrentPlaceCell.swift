//
//  CurrentPlaceCell.swift
//  HookahPlaces
//
//  Created by Евгений on 02/11/2018.
//  Copyright © 2018 Momotov. All rights reserved.
//

import UIKit

class CurrentPlaceCell: UITableViewCell {

    @IBOutlet weak var viewPlace: UIView!
    @IBOutlet weak var namePlaceLabel: UILabel!
    @IBOutlet weak var imagePlace: UIImageView!
    @IBOutlet weak var exitFromPlaceButton: UIButton!
    
    func initCell(for place: Place?) {
        namePlaceLabel.text = "\(place?.name ?? "") \(place?.metro ?? "")"
        if let image = place?.image {
            imagePlace.image = UIImage(data: image as Data)
        }
        viewPlace.layer.cornerRadius = 5
        viewPlace.layer.borderColor = UIColor.black.cgColor
        viewPlace.layer.borderWidth = 2
        viewPlace.clipsToBounds = true
        imagePlace.layer.cornerRadius = imagePlace.frame.height / 2
        imagePlace.clipsToBounds = true
        exitFromPlaceButton.layer.cornerRadius = 5
        exitFromPlaceButton.clipsToBounds = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
