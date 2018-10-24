//
//  ApplicationManager.swift
//  PitneyBowes
//
//  Created by Zubair.Nagori on 24/10/18.
//  Copyright © 2018 mac. All rights reserved.
//

import Foundation

class ApplicationManager {

    static let shared = ApplicationManager()
    
    var loggedInUserId: String?
    var shipmentType: String?
}

