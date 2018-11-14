//
//  PlaceMainCell.swift
//  HookahPlaces
//
//  Created by Евгений on 02/11/2018.
//  Copyright © 2018 Momotov. All rights reserved.
//

import UIKit

class PlaceMainCell: UITableViewCell {

    @IBOutlet weak var imagePlace: UIImageView!
    @IBOutlet weak var namePlaceLabel: UILabel!
    @IBOutlet weak var addressPlaceLabel: UILabel!
    @IBOutlet weak var ratingPlaceLabel: UILabel!
    @IBOutlet weak var distancePlaceLabel: UILabel!
    
    func initCell(with place: Place) {
        if let image = place.image {
            imagePlace.image = UIImage(data: image as Data)
        }
        namePlaceLabel.text = "\(place.name!) \(place.metro!)"
        addressPlaceLabel.text = place.address
        ratingPlaceLabel.text = "\(place.rating)"
        distancePlaceLabel.text = "\(place.distance) км"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
