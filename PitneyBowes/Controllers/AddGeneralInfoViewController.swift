//
//  SecondViewController.swift
//  ConstantIpadView
//
//  Created by mac on 12/10/18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit

class AddGeneralInfoViewController: UIViewController {
    
    enum SelectedTextFieldType {
        case ngsLocation
        case originOrDestination
    }
    
    @IBOutlet weak var txtBol: UITextField!
    @IBOutlet weak var txtPro: UITextField!
    @IBOutlet weak var txtCarrier: UITextField!
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var txtOriginOrDestination: UITextField!
    @IBOutlet weak var txtSealNumber: UITextField!
    
    @IBOutlet weak var lblSealNumber: UILabel!
    @IBOutlet weak var lblOriginOrDestination: UILabel!

    @IBOutlet weak var viewPickerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewPicker: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    //Select ngs location by default
    var selectedTextField: SelectedTextFieldType = .ngsLocation
    
    var latitude = 0.0
    var longitude = 0.0
    
    var arrLocations = [Location]()
    var selectedLocation: Location?
    
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
        
        callGetLocationsAPI()
    }
    
    @IBAction func cancelSelection(_ sender: RoundedBorderButton) {
        showHideLocationPicker(isShow: false)
    }
    @IBAction func doneSelection(_ sender: RoundedBorderButton) {
        showHideLocationPicker(isShow: false)
    }
    
    @objc func cancel(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func selectNgsLocationTapped(_ sender: UIButton) {
        selectedTextField = .ngsLocation
        showHideLocationPicker(isShow: true)
    }
    @IBAction func selectOriginOrDestinationTapped(_ sender: UIButton) {
        selectedTextField = .originOrDestination
        showHideLocationPicker(isShow: true)

    }
    @objc func saveGeneralInfo() {
        print("Save General Info Tapped")
        
        let isInputValid = validateInput()
        
        switch isInputValid {
        case .valid:
            
            //Change: API won't be called now as per dicussion with shilpa
            //callSaveGeneralInfoAPI()
            print("Save info")
        case .invalid(let message):
            presentAlert(withTitle: message, message: "")
        }
        
    }
    
    func showHideLocationPicker(isShow: Bool) {
        if isShow {
            viewPickerBottomConstraint.constant = 0
        }
        else {
            viewPickerBottomConstraint.constant = -(viewPicker.frame.height)
        }
        
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
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
        else if (txtOriginOrDestination.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)! {
            return .invalid("Please enter origin.")
        }

        
        return.valid
    }
    
    func callSaveGeneralInfoAPI() {
        guard let loggedInUserId = ApplicationManager.shared.loggedInUserId else {
            return
        }
        
        guard let type  = ApplicationManager.shared.shipmentType else {
            return
        }
        
        let queryString = "user_id=\(loggedInUserId)&type=\(type)&bol=\(txtBol.text!)&carrier=\(txtCarrier.text!)&ngs_location=\(txtLocation.text!)&origin=\(txtOriginOrDestination.text!)&latitude=\(latitude)&longitude=\(longitude)"
        
        APIManager.executeRequest(appendingPath: "shipments/add", withQueryString: queryString, httpMethod: "POST") { (data, error) in
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
    
    func callGetLocationsAPI() {
        let type = ApplicationManager.shared.shipmentType == "INBOUND" ? "origin" : "destination"
        
        guard let userId = ApplicationManager.shared.loggedInUserId else {
            return
        }
        
        let queryString = "type=\(type)&user_id=\(userId)"
        
        APIManager.executeRequest(appendingPath: "locations", withQueryString: queryString, httpMethod: "GET") { (data, error) in
            if error != nil {
                print("Unable to fetch locations: \(error!.localizedDescription)")
                return
            }
            
            guard let responseData = data else {
                return
            }
            
            do {
                let locations = try JSONDecoder().decode(Locations.self, from: responseData)
                
                guard let locationsArray = locations.data else {
                    return
                }
                
                self.arrLocations = locationsArray
                
                DispatchQueue.main.async {
                    self.pickerView.reloadAllComponents()
                }
                
            }
            catch let error {
                print(error.localizedDescription)
            }
        }
    }
}


extension AddGeneralInfoViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrLocations[row].name
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedLocation = arrLocations[row]
        
        if selectedTextField == .ngsLocation {
            txtLocation.text = selectedLocation?.name
        }
        else {
            txtOriginOrDestination.text = selectedLocation?.name
        }
    }
}

extension AddGeneralInfoViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrLocations.count
    }
}
