//
//  Result.swift
//  RestaurantFinder
//
//  Created by Yaroslav Skachkov on 31.07.2018.
//  Copyright © 2018 Yaroslav Skachkov. All rights reserved.
//

import Foundation

struct Result: Codable {
    let html_attributions: [String]?
    let next_page_token: String?
    let results: [Results]?
}

struct Results: Codable {
    let geometry: Geometry?
    let icon: String?
    let id: String?
    let name: String?
    let opening_hours: OpeningHours?
    let photos: [Photos]?
    let place_id: String?
    let plus_code: PlusCode?
    let rating: Double?
    let reference: String?
    let scope: String?
    let types: [String]?
    let vicinity: String?
}

struct Geometry: Codable {
    let location: Location?
    let viewport: Viewport?
}

struct Location: Codable {
    let lat: Double?
    let lng: Double?
}

struct Viewport: Codable {
    let northeast: Location?
    let southwest: Location?
}

struct OpeningHours: Codable {
    let open_now: Bool?
}

struct PlusCode: Codable {
    let compound_code: String?
    let global_code: String?
}

struct Photos: Codable {
    let height: Int?
    let html_attributions: [String]?
    let photo_reference: String?
    let width: Int?
}
