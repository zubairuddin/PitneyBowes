//
//  Shipment.swift
//  PitneyBowes
//
//  Created by Zubair.Nagori on 24/10/18.
//  Copyright © 2018 mac. All rights reserved.
//

import Foundation

struct ShipmentDetail: Decodable {
    let id: String?
    let type: String?
    let bol: String?
    let pro_number: String?
    let user_id: String?
    let carrier: String?
    let ngs_location: String?
    let latitude: String?
    let longitude: String?
    let origin: String?
    let created: String?
    let edited: String?
}
struct ShipmentUser: Decodable {
    let id: String?
    let questionairre_id: String?
    let email: String?
}

struct Shipment: Decodable {
    let Shipment: ShipmentDetail?
    let User: UserDetail?
}

struct ShipmentData: Decodable {
    var shipments: [Shipment]?
}
