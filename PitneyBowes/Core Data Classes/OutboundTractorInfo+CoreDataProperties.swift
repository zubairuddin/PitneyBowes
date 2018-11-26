//
//  OutboundTractorInfo+CoreDataProperties.swift
//  PitneyBowes
//
//  Created by Zubair on 25/11/18.
//  Copyright © 2018 mac. All rights reserved.
//
//

import Foundation
import CoreData


extension OutboundTractorInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OutboundTractorInfo> {
        return NSFetchRequest<OutboundTractorInfo>(entityName: "OutboundTractorInfo")
    }

    @NSManaged public var images: NSObject?
    @NSManaged public var lockOnTrailer: String
    @NSManaged public var tractorDotNumber: String
    @NSManaged public var tractorPlate: String
    @NSManaged public var trailerNumber: String
    @NSManaged public var trailerPlateState: String

}
