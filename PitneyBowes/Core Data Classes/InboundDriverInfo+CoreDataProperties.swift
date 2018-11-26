//
//  InboundDriverInfo+CoreDataProperties.swift
//  PitneyBowes
//
//  Created by Zubair on 25/11/18.
//  Copyright © 2018 mac. All rights reserved.
//
//

import Foundation
import CoreData


extension InboundDriverInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<InboundDriverInfo> {
        return NSFetchRequest<InboundDriverInfo>(entityName: "InboundDriverInfo")
    }

    @NSManaged public var driverName: String
    @NSManaged public var lockOnTrailer: String
    @NSManaged public var sealNumber: String

}
