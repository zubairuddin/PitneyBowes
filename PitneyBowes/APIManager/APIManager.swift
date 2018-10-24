//
//  APIManager.swift
//  PitneyBowes
//
//  Created by Zubair on 23/10/18.
//  Copyright © 2018 mac. All rights reserved.
//

import Foundation

class APIManager {
    
    class func executeRequest(appendingPath: String, withQueryString queryString: String, completionHandler:@escaping (Data?,Error?)->()) {
        
        //Get the url by appending query string
        guard let requestUrl = queryString.urlFromQueryString(appendingPath: appendingPath) else {
            print("Unable to create url")
            return
        }
        
        //Create the request
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //Initiate the dataTask
        let task = URLSession.shared.dataTask(with: request) { (responseData, urlResponse, error) in
            
            if error != nil {
                print("Error: \(error!.localizedDescription)")
                completionHandler(nil,error)
                return
            }
            
            guard let data = responseData else {
                completionHandler(nil,error)
                return
            }
            
            completionHandler(data,nil)
        }
            
        task.resume()
    }
    
}


