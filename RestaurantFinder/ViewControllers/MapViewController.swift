//
//  MapViewController.swift
//  RestaurantFinder
//
//  Created by Yaroslav Skachkov on 30.07.2018.
//  Copyright © 2018 Yaroslav Skachkov. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class MapViewController: UIViewController {
    
    private let dataProvider = GoogleDataProvider.sharedGoogleDataProvider
    private let searchRadius: Double = 20000
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 10
    var searchedTypes = ["restaurant"]
    
    var defaultLocation = CLLocation(latitude: -33.86, longitude: 151.20)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 400
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        placesClient = GMSPlacesClient.shared()
        
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude, longitude: defaultLocation.coordinate.longitude, zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: self.view.bounds, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
        
        view.addSubview(mapView)
        mapView.isHidden = false
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        restaurantsFinder()
    }
    
    func restaurantsFinder() {
        if let myLocation = locationManager.location {
            print(myLocation.coordinate)
            dataProvider.fetchPlacesNearCoordinate(myLocation.coordinate, radius: searchRadius, types: searchedTypes) { places in
                for place in places {
                    let marker = PlaceMarker(place: place)
                    marker.title = place.name
                    marker.map = self.mapView
                    marker.userData = place
                }
            }
        }
    }
    
}

extension MapViewController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: zoomLevel)
        
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}

extension MapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        print(marker.position)
        let restaurantInfoVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "RestaurantInformation") as? RestaurantInformation
        self.navigationController?.pushViewController(restaurantInfoVC!, animated: true)
        
        if let restaurant = marker.userData as? Place {
            restaurantInfoVC?.restaurant = restaurant
        }
        
        GoogleDataProvider.resultsArr = []
        mapView.clear()
        print(marker.userData)
        
        return true
    }
}
