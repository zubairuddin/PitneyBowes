//
//  SavedInbound+CoreDataProperties.swift
//  PitneyBowes
//
//  Created by Zubair on 24/11/18.
//  Copyright © 2018 mac. All rights reserved.
//
//

import Foundation
import CoreData


extension SavedInbound {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedInbound> {
        return NSFetchRequest<SavedInbound>(entityName: "SavedInbound")
    }

    @NSManaged public var driverInfo: InboundDriverInfo?
    @NSManaged public var generalInfo: InboundGeneralInfo?

}
