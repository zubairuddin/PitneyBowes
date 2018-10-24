//
//  FirstViewController.swift
//  ConstantIpadView
//
//  Created by mac on 11/10/18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit

class GeneralInfoViewController: UIViewController{
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "General Info Entries"
        
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add(_:)))
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchGeneralInfoEntries()
    }
   
     @objc func add(_ sender: Any){
        let next = self.storyboard?.instantiateViewController(withIdentifier: "AddGeneralInfoViewController")as! AddGeneralInfoViewController
        self.navigationController?.pushViewController(next, animated:true)
    }
    
    func fetchGeneralInfoEntries() {
        //http://smartpro-technologies.com/api/shipments/index?user_id=NzY=&type=INBOUND
        
        guard let userId = ApplicationManager.shared.loggedInUserId, let type = ApplicationManager.shared.shipmentType else {
            return
        }
        
        let queryString = "user_id=\(userId)&type=\(type)"
        APIManager.executeRequest(appendingPath: "shipments/index", withQueryString: queryString) { (data, error) in
            if error != nil {
                print("Error while fetching shipments: \(error!.localizedDescription)")
                return
            }
            
            guard let responseData = data else {
                return
            }
            
            let json = try! JSONSerialization.jsonObject(with: responseData, options: .allowFragments)
            print(json)
            
            //Decode the info and reload table view
            
            do {
                let shipments = try JSONDecoder().decode(ShipmentData.self, from: responseData)
                print(shipments)
            }
            catch let error {
                print("Unable to decode: \(error.localizedDescription)")
            }
            
        }

    }
    
}
    
  


