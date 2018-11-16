//
//  OutboundQuestionnaireInfo+CoreDataProperties.swift
//  PitneyBowes
//
//  Created by Zubair on 08/11/18.
//  Copyright © 2018 mac. All rights reserved.
//
//

import Foundation
import CoreData


extension OutboundQuestionnaireInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OutboundQuestionnaireInfo> {
        return NSFetchRequest<OutboundQuestionnaireInfo>(entityName: "OutboundQuestionnaireInfo")
    }

    @NSManaged public var alertContact: Bool
    @NSManaged public var carryPassengers: Bool
    @NSManaged public var discussShipment: Bool
    @NSManaged public var receiptAcknowledge: Bool
    @NSManaged public var signature: NSObject

}
