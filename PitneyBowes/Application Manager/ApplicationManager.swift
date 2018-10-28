//
//  ApplicationManager.swift
//  PitneyBowes
//
//  Created by Rizwan.Nagori on 24/10/18.
//  Copyright © 2018 mac. All rights reserved.
//

import Foundation

class ApplicationManager {

    enum ShipmentType {
        case INBOUND
        case OUTBOUND
    }
    
    static let shared = ApplicationManager()
    
    var loggedInUserId: String?
    var shipmentType: ShipmentType?
}

