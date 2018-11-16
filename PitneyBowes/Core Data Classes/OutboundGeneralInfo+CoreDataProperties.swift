//
//  OutboundGeneralInfo+CoreDataProperties.swift
//  PitneyBowes
//
//  Created by Zubair on 15/11/18.
//  Copyright © 2018 mac. All rights reserved.
//
//

import Foundation
import CoreData


extension OutboundGeneralInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OutboundGeneralInfo> {
        return NSFetchRequest<OutboundGeneralInfo>(entityName: "OutboundGeneralInfo")
    }

    @NSManaged public var bolNumber: String
    @NSManaged public var carrier: String
    @NSManaged public var destination: String
    @NSManaged public var employeeName: String
    @NSManaged public var latitude: String
    @NSManaged public var longitude: String
    @NSManaged public var ngsLocation: String
    @NSManaged public var proNumber: String
    @NSManaged public var sealNumber: String
    @NSManaged public var stateCode: String

}
