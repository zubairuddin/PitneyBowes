//
//  Employee.swift
//  PitneyBowes
//
//  Created by Rizwan.Nagori on 26/10/18.
//  Copyright © 2018 mac. All rights reserved.
//

import Foundation

struct EmployeeDetails: Decodable {
    let id: String
    let name: String
}
struct Employee: Decodable {
    let Employee: EmployeeDetails?
}
struct Employees: Decodable {
    let data: [Employee]?
}

