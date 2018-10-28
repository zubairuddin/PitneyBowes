//
//  APIManager.swift
//  PitneyBowes
//
//  Created by Rizwan on 23/10/18.
//  Copyright © 2018 mac. All rights reserved.
//

import Foundation
import UIKit

class APIManager {
    
    class func executeRequest(appendingPath: String, withQueryString queryString: String, httpMethod: String, completionHandler:@escaping (Data?,Error?)->()) {
        
        //Get the url by appending query string
        guard let requestUrl = queryString.urlFromQueryString(appendingPath: appendingPath) else {
            print("Unable to create url")
            return
        }
        
        //Create the request
        var request = URLRequest(url: requestUrl)
        request.httpMethod = httpMethod
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
    
    class func saveOutboundInfo(appendingPath: String, withQueryString queryString: String, paramerer: [[String:UIImage]], completionHandler:@escaping (Data?,Error?)->()) {
        
        //Get the url by appending query string
        guard let requestUrl = queryString.urlFromQueryString(appendingPath: appendingPath) else {
            print("Unable to create url")
            return
        }
    
        //Create the request
        guard let request = createRequest(withUrl: requestUrl, parameters: paramerer) else {
            return
        }
        
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
    
    class func createRequest(withUrl requestUrl: URL, parameters: [[String:UIImage]]) -> URLRequest? {
        
        print(parameters)
        
        let boundary = generateBoundaryString()
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 300
        
        //Create HTTP body
        var body = Data()
        
        for image in parameters {
            for (key, value) in image {
                
                let filename = key
                
                guard let data = UIImageJPEGRepresentation(value,0.1) else {
                    return nil
                }
                
                let mimetype = "image/jpg"
                
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(filename)\"\r\n")
                body.appendString("Content-Type: \(mimetype)\r\n\r\n")
                body.append(data)
                body.appendString("\r\n")
            }
            
            body.appendString("--\(boundary)--\r\n")
        }
        
        
        request.httpBody = body
        
        return request
    }
    
    class func generateBoundaryString() -> String
    {
        return "Boundary-\(UUID().uuidString)"
    }
}



extension Data {
    mutating func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}
