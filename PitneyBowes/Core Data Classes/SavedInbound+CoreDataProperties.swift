//
//  SavedInbound+CoreDataProperties.swift
//  PitneyBowes
//
//  Created by Zubair on 07/11/18.
//  Copyright © 2018 mac. All rights reserved.
//
//

import Foundation
import CoreData


extension SavedInbound {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedInbound> {
        return NSFetchRequest<SavedInbound>(entityName: "SavedInbound")
    }

    @NSManaged public var generalInfo: InboundGeneralInfo?
    @NSManaged public var driverInfo: InboundDriverInfo?

}
