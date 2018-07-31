//
//  DataManager.swift
//  RestaurantFinder
//
//  Created by Yaroslav Skachkov on 31.07.2018.
//  Copyright © 2018 Yaroslav Skachkov. All rights reserved.
//

import Foundation

class DataManager {
    static let shared = DataManager()
    static let baseUrl = "https://maps.googleapis.com"
}

extension DataManager {
    func decode<T>(model: T.Type, from data: Data?) -> T? where T: Decodable {
        guard let data = data else { return nil }
        do {
            return try JSONDecoder().decode(model, from: data)
        } catch let error {
            assert(false, "Error while decoding \(model) from \(data), error - \(error.localizedDescription)")
            return nil
        }
    }
}
