//
//  Extensions.swift
//  PitneyBowes
//
//  Created by Zubair on 24/10/18.
//  Copyright © 2018 mac. All rights reserved.
//

import Foundation

extension String {
    
    func urlFromQueryString()-> URL? {
        
        guard var components = URLComponents(string: KBASEURL) else {
            print("Invalid base url.")
            return nil
        }
        
        components.query = self
        
        guard let url = components.url else {
            return nil
        }
        
        print("URL for the request is \(url)")
        
        return url
    }
}
