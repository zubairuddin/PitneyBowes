//
//  APIManager.swift
//  PitneyBowes
//
//  Created by Zubair on 23/10/18.
//  Copyright © 2018 mac. All rights reserved.
//

import Foundation

class APIManager {
    
    class func executeRequest(withQueryString queryString: String) {
        
        guard let requestUrl = queryString.urlFromQueryString() else {
            print("Unable to create url")
            return
        }
        
        let task = URLSession.shared.dataTask(with: requestUrl) { (responseData, urlResponse, error) in
            
            if error != nil {
                print("Error:)")
            }
            
            guard let data = responseData else {
                return
            }
            
            let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments)
            print(json)
        }
        
        task.resume()
    }
}
