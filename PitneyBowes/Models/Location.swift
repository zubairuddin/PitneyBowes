//
//  Location.swift
//  PitneyBowes
//
//  Created by Rizwan on 25/10/18.
//  Copyright © 2018 mac. All rights reserved.
//

import Foundation

struct Location: Decodable {
    let id: String?
    let name: String?
    let state_code: String?
}

struct Locations: Decodable {
    let data: [Location]?
}

struct NgsLocation: Decodable {
    let location: String?
    let latitude: String?
    let longitude: String?
}

struct AllNgsLocations: Decodable {
    let data: [NgsLocation]?
}
