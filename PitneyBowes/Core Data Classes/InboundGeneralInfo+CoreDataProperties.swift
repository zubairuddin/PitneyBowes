//
//  InboundGeneralInfo+CoreDataProperties.swift
//  PitneyBowes
//
//  Created by Zubair on 25/11/18.
//  Copyright © 2018 mac. All rights reserved.
//
//

import Foundation
import CoreData


extension InboundGeneralInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<InboundGeneralInfo> {
        return NSFetchRequest<InboundGeneralInfo>(entityName: "InboundGeneralInfo")
    }

    @NSManaged public var carrier: String
    @NSManaged public var employeeName: String
    @NSManaged public var latitude: String
    @NSManaged public var longitude: String
    @NSManaged public var ngsLocation: String
    @NSManaged public var stateCode: String
    @NSManaged public var bolAndProdetails: NSObject?
    @NSManaged public var isShipmentBrokered: String?
    @NSManaged public var brokeredBy: String?

}
