//
//  RestaurantInformation.swift
//  RestaurantFinder
//
//  Created by Yaroslav Skachkov on 31.07.2018.
//  Copyright © 2018 Yaroslav Skachkov. All rights reserved.
//

import UIKit

class RestaurantInformation: UIViewController {
    
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var restaurantsLatLabel: UILabel!
    @IBOutlet weak var restaurantsLngLabel: UILabel!
    @IBOutlet weak var restaurantsAddressLabel: UILabel!
    @IBOutlet weak var restaurantPhotoImageView: UIImageView!
    
    var restaurantName: String?
    var restaurantLat: String?
    var restaurantLng: String?
    var restaurantAddress: String?
    var restauurantPhotoReference: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        restaurantNameLabel.text = restaurantName
        restaurantsLatLabel.text = restaurantLat
        restaurantsLngLabel.text = restaurantLng
        restaurantsAddressLabel.text = restaurantAddress
        
        self.navigationController?.title = "Restaurant Information"
    }
}

