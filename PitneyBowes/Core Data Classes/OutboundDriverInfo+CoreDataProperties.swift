//
//  OutboundDriverInfo+CoreDataProperties.swift
//  PitneyBowes
//
//  Created by Zubair on 15/11/18.
//  Copyright © 2018 mac. All rights reserved.
//
//

import Foundation
import CoreData


extension OutboundDriverInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OutboundDriverInfo> {
        return NSFetchRequest<OutboundDriverInfo>(entityName: "OutboundDriverInfo")
    }

    @NSManaged public var driverName: String
    @NSManaged public var lockOnTrailer: String
    @NSManaged public var sealNumber: String

}
