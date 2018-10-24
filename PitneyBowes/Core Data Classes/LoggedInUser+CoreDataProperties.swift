//
//  LoggedInUser+CoreDataProperties.swift
//  PitneyBowes
//
//  Created by Zubair.Nagori on 24/10/18.
//  Copyright © 2018 mac. All rights reserved.
//
//

import Foundation
import CoreData


extension LoggedInUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LoggedInUser> {
        return NSFetchRequest<LoggedInUser>(entityName: "LoggedInUser")
    }

    @NSManaged public var userId: String
    @NSManaged public var userEmail: String

}
