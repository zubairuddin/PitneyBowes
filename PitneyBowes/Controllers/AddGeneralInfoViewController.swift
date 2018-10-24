//
//  SecondViewController.swift
//  ConstantIpadView
//
//  Created by mac on 12/10/18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit

class AddGeneralInfoViewController: UIViewController {
        
    @IBOutlet weak var txtBol: UITextField!
    @IBOutlet weak var txtPro: UITextField!
    @IBOutlet weak var txtCarrier: UITextField!
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var txtOrigin: UITextField!
    @IBOutlet weak var txtSealNumber: UITextField!
    
    @IBOutlet weak var lblSealNumber: UILabel!
    @IBOutlet weak var lblOriginOrDestination: UILabel!

    var latitude = 0.0
    var longitude = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "General Information"
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        let cancleButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel,
                                           target: self,
                                           action: #selector(cancel(_:)))
        self.navigationItem.leftBarButtonItem = cancleButton
        
        
        let saveButton = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.plain, target: self, action: #selector(saveGeneralInfo))
        self.navigationItem.rightBarButtonItem = saveButton
        
        //Manage inbound/outbound shipments
        guard let type = ApplicationManager.shared.shipmentType else {
            return
        }
        
        if type == "INBOUND" {
            print("inbound shipment")
            lblSealNumber.isHidden = true
            txtSealNumber.isHidden = true
            lblOriginOrDestination.text = "Origin"
        }
        else {
            print("outbound shipment")
            lblSealNumber.isHidden = false
            txtSealNumber.isHidden = false
            lblOriginOrDestination.text = "Destination"
        }
    }
    
    @objc func cancel(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func saveGeneralInfo() {
        print("Save General Info Tapped")
        
        let isInputValid = validateInput()
        
        switch isInputValid {
        case .valid:
            callSaveGeneralInfoAPI()
        case .invalid(let message):
            presentAlert(withTitle: message, message: "")
        }
        
    }
    
    //Input validation
    func validateInput() ->ValidateData {
        if (txtBol.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)! {
            return .invalid("Please enter BOL number.")
        }
        else if (txtPro.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)! {
            return .invalid("Please enter Pro number.")
        }
        else if (txtCarrier.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)! {
            return .invalid("Please enter carrier.")
        }
        else if (txtLocation.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)! {
            return .invalid("Please enter location.")
        }
        else if (txtOrigin.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)! {
            return .invalid("Please enter origin.")
        }

        
        return.valid
    }
    
    func callSaveGeneralInfoAPI() {
        //http://smartpro-technologies.com/api/shipments/add?user_id=Nzy=&type=INBOUND&bol=qwerty&carrier=delhivery&ngs_location=Bhopal&origin=Ca, USA&latitude=123.01.09.01&longitude=09.09.09.81

        guard let loggedInUserId = ApplicationManager.shared.loggedInUserId else {
            return
        }
        
        guard let type  = ApplicationManager.shared.shipmentType else {
            return
        }
        
        let queryString = "user_id=\(loggedInUserId)&type=\(type)&bol=\(txtBol.text!)&carrier=\(txtCarrier.text!)&ngs_location=\(txtLocation.text!)&origin=\(txtOrigin.text!)&latitude=\(latitude)&longitude=\(longitude)"
        
        APIManager.executeRequest(appendingPath: "shipments/add", withQueryString: queryString) { (data, error) in
            if error != nil {
                print("Error: \(error!.localizedDescription)")
                return
            }
            
            guard let responseData = data else {
                return
            }
            
            if let json = try? JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as! [String:Any] {
                
                print(json)
                if let intError = json["error"] as? Int {
                    print(intError)
                    
                    if intError == 0 {
                        //Shipment saved successfully
                        DispatchQueue.main.async {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                    else {
                        //Handle error
                        let message = json["message"] as! String
                        DispatchQueue.main.async {
                            self.presentAlert(withTitle: message, message: "")
                        }
                   }
                }
            }
        }
    }
}



