//
//  User.swift
//  PitneyBowes
//
//  Created by Rizwan on 23/10/18.
//  Copyright © 2018 mac. All rights reserved.
//

import Foundation

struct UserDetail: Decodable {
    let id: String?
    let questionairre_id: String?
    let email: String?
    let url: String?
    let name: String?
    let gender: String?
    let phone: String?
    let address: String?
    let type: String?
    let country: String?
}
struct User: Decodable {
    let User: UserDetail?
}
struct UserData: Decodable {
    var data: [User]?
}

