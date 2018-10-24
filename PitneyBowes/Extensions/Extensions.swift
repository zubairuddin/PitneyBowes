//
//  Extensions.swift
//  PitneyBowes
//
//  Created by Zubair on 24/10/18.
//  Copyright © 2018 mac. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD
extension String {
    
    func urlFromQueryString(appendingPath: String)-> URL? {
        
        let strUrlPath = KBASEURL + appendingPath
        
        guard var components = URLComponents(string: strUrlPath) else {
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

extension UIViewController {
    func presentAlert(withTitle title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func hideHud() {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }
        
    }
}
