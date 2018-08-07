//
//  GoogleDataProvider.swift
//  RestaurantFinder
//
//  Created by Yaroslav Skachkov on 31.07.2018.
//  Copyright © 2018 Yaroslav Skachkov. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

typealias PlacesCompletion = ([Place]) -> Void
typealias PhotoCompletion = (UIImage?) -> Void

class GoogleDataProvider {
    
    private static var photoCache: [String: UIImage] = [:]
    
    static let sharedGoogleDataProvider = GoogleDataProvider()
    
    private init() {}
    
    let sessionManager = SessionManager()
    static var jsonFromGoogleAPI: Any?
    static var resultsArr: [Place] = []
    
    func fetchPlacesNearCoordinate(_ coordinate: CLLocationCoordinate2D, radius: Double, types:[String], completion: @escaping PlacesCompletion) {
        
        let nearbySearchPath = "/maps/api/place/nearbysearch/json?location=\(coordinate.latitude),\(coordinate.longitude)&radius=\(radius)&sensor=true&key=\(googleApiKey)"
        var searchURL = DataManager.baseUrl + nearbySearchPath
        
        let typesString = types.count > 0 ? types.joined(separator: "|") : "food"
        searchURL += "&types=\(typesString)"
        searchURL = searchURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? searchURL
        
        Alamofire.request(searchURL, method: .post, encoding: JSONEncoding.default).responseJSON { response in
            if let itemData = response.data {
                let model = DataManager.shared.decode(model: PlaceSearchResults.self, from: itemData)
                if let results = model?.results {
                    results.forEach { result in
                        GoogleDataProvider.resultsArr.append(result)
                    }
                }
            }
            print(GoogleDataProvider.resultsArr)
            print(GoogleDataProvider.resultsArr.count)
            completion(GoogleDataProvider.resultsArr)
        }
    }
    
    
    // TODO
    func fetchPhotoFromReference(_ reference: String, completion: @escaping PhotoCompletion) {
        if let photo = GoogleDataProvider.photoCache[reference] {
            completion(photo)
        } else {
            let urlString = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=200&photoreference=\(reference)&key=\(googleApiKey)"
            guard let url = URL(string: urlString) else {
                completion(nil)
                return
            }
            
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }
            
            Alamofire.download(url).responseJSON { response in
                var downloadedPhoto: UIImage? = nil
                defer {
                    completion(downloadedPhoto)
                }
                guard let imageData = try? Data(contentsOf: url) else {
                    return
                }
                downloadedPhoto = UIImage(data: imageData)
                GoogleDataProvider.photoCache[reference] = downloadedPhoto
            }
        }
    }
}
