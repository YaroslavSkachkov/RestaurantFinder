//
//  PlaceMarker.swift
//  RestaurantFinder
//
//  Created by Yaroslav Skachkov on 31.07.2018.
//  Copyright © 2018 Yaroslav Skachkov. All rights reserved.
//

import UIKit
import GoogleMaps

class PlaceMarker: GMSMarker {
    let place: Results
    
    init(place: Results) {
        self.place = place
        super.init()
        
        if let lat = place.geometry?.location?.lat, let lng = place.geometry?.location?.lng {
            position = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            groundAnchor = CGPoint(x: 0.5, y: 1)
            appearAnimation = .pop
        }
    }
}
