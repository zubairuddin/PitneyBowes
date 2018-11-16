//
//  SavedOutbound+CoreDataProperties.swift
//  PitneyBowes
//
//  Created by Zubair on 07/11/18.
//  Copyright © 2018 mac. All rights reserved.
//
//

import Foundation
import CoreData


extension SavedOutbound {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedOutbound> {
        return NSFetchRequest<SavedOutbound>(entityName: "SavedOutbound")
    }

    @NSManaged public var generalInfo: OutboundGeneralInfo?
    @NSManaged public var driverInfo: OutboundDriverInfo?
    @NSManaged public var tractorInfo: OutboundTractorInfo?
    @NSManaged public var questionnaireInfo: OutboundQuestionnaireInfo?

}
