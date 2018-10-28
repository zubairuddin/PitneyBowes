//
//  DatabaseManager.swift
//  PitneyBowes
//
//  Created by Rizwan.Nagori on 24/10/18.
//  Copyright © 2018 mac. All rights reserved.
//

import Foundation
import CoreData

class DatabaseManager {

//    class func saveLoggedInUserInCoreData(userDetail: UserDetail) {
//        
//        let objLoggedInUser = LoggedInUser(context: MANAGED_OBJECT_CONTEXT)
//        
//        guard let id = userDetail.id, let emailAddress = userDetail.email else {
//            return
//        }
//        
//        objLoggedInUser.userId = id
//        objLoggedInUser.userEmail = emailAddress
//        
//        do {
//            try MANAGED_OBJECT_CONTEXT.save()
//        }
//        catch let error {
//            print("Unable to save: \(error.localizedDescription)")
//        }
//    }
//    
//    class func getLoggedInUserFromCoreData()-> LoggedInUser? {
//        let fetchRequest: NSFetchRequest<LoggedInUser> = LoggedInUser.fetchRequest()
//        
//        do {
//             let result = try MANAGED_OBJECT_CONTEXT.fetch(fetchRequest)
//            let user = result.last
//            return user
//        }
//        catch let error {
//            print("Unable to fetch: \(error.localizedDescription)")
//            return nil
//        }
//    }
}
