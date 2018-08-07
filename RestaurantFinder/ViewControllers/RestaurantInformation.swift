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
    
    private let dataProvider = GoogleDataProvider.sharedGoogleDataProvider
    
    var restaurant: Place?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataProvider.fetchPhotoFromReference((restaurant?.photos![0].photo_reference)!) { image in
            self.restaurantPhotoImageView.image = image
        }
        
        restaurantNameLabel.text = restaurant?.name
        restaurantsLatLabel.text = String(restaurant?.geometry?.location?.lat ?? 0)
        restaurantsLngLabel.text = String(restaurant?.geometry?.location?.lng ?? 0)
        restaurantsAddressLabel.text = restaurant?.vicinity
        
        self.navigationController?.title = "Restaurant Information"
    }
}

