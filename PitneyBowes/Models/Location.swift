//
//  Location.swift
//  PitneyBowes
//
//  Created by Zubair on 25/10/18.
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

