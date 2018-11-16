//
//  SixViewController.swift
//  ConstantIpadView
//
//  Created by mac on 14/10/18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit

struct InboundShipmentDriverInfo {
    var driverName: String
    var sealNumber: String
    var isLockOnTrailer: String
}

struct OutboundShipmentDriverInfo {
    var driverName: String
    var sealNumber: String
    var isLockOnTrailer: String
}

protocol SaveInboundDriverInfoProtocol {
    func didSaveInboundShipmentDriverInfo(driverInfo: InboundShipmentDriverInfo)
}

protocol SaveOutboundDriverInfoProtocol {
    func didSaveOutboundShipmentDriverInfo(driverInfo: OutboundShipmentDriverInfo)
}

class DriverSeallnfoViewController: UIViewController {

    @IBOutlet weak var txtDriverName: UITextField!
    @IBOutlet weak var txtSealNumber: UITextField!
    @IBOutlet weak var segmentIsLock: UISegmentedControl!
    
    var strIsLock = "Yes"
    
    var inboundDriverInfoDelegate: SaveInboundDriverInfoProtocol?
    var outboundDriverInfoDelegate: SaveOutboundDriverInfoProtocol?
    
    var inboundDriverAndSealInfo: InboundDriverInfo?
    var outboundDriverAndSealInfo: OutboundDriverInfo?
    
    let type = ApplicationManager.shared.shipmentType
    
    override func viewDidLoad() {
        super.viewDidLoad()
       self.title = "Driver and Seal Information"
        
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveDriverInfoTapped))
        navigationItem.rightBarButtonItem = saveButton
        
        if type == .INBOUND {
            //If driver info is available from saved shipment, show it on text fields
            if let info = inboundDriverAndSealInfo {
                txtDriverName.text = info.driverName
                txtSealNumber.text = info.sealNumber
                
                switch info.lockOnTrailer {
                case "Yes":
                    segmentIsLock.selectedSegmentIndex = 0
                case "No":
                    segmentIsLock.selectedSegmentIndex = 1
                default:
                    break
                }
            }
        }
        else {
            //If driver info is available from saved shipment, show it on text fields
            if let info = outboundDriverAndSealInfo {
                txtDriverName.text = info.driverName
                txtSealNumber.text = info.sealNumber
                
                switch info.lockOnTrailer {
                case "Yes":
                    segmentIsLock.selectedSegmentIndex = 0
                case "No":
                    segmentIsLock.selectedSegmentIndex = 1
                default:
                    break
                }
            }
        }
        
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            strIsLock = "Yes"
        case 1:
            strIsLock = "No"
            
        default:
            break
        }
    }
    @IBAction func noSealAction(_ sender: UIButton) {
        txtSealNumber.text = "N/A"
    }
    
    @objc func saveDriverInfoTapped() {
        
        let isValidInputValid = validateInput()
        
        switch isValidInputValid {
        case .valid:
            saveData()
        case .invalid(let message):
            presentAlert(withTitle: message, message: "")
        }
    }
    
    func saveData() {
        guard let type = ApplicationManager.shared.shipmentType else {
            return
        }
        
        if type == .INBOUND {
            let driverName = txtDriverName.text!
            let sealNumber = txtSealNumber.text!
            
            let driverInfo = InboundShipmentDriverInfo(driverName: driverName, sealNumber: sealNumber, isLockOnTrailer: strIsLock)
            inboundDriverInfoDelegate?.didSaveInboundShipmentDriverInfo(driverInfo: driverInfo)
        }
            
        else if type  == .OUTBOUND {
            let driverName = txtDriverName.text!
            let sealNumber = txtSealNumber.text!
            
            let driverInfo = OutboundShipmentDriverInfo(driverName: driverName, sealNumber: sealNumber, isLockOnTrailer: strIsLock)
            
            outboundDriverInfoDelegate?.didSaveOutboundShipmentDriverInfo(driverInfo: driverInfo)
        }
        
        navigationController?.popViewController(animated: true)

    }
    func validateInput() ->ValidateData {
        if (txtDriverName.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)! {
            return .invalid("Please enter driver name.")
        }
        else if (txtSealNumber.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)! {
            return .invalid("Please enter seal number or select No Seal if it is not applicable.")
        }
        
        return.valid
    }
    func popToInboundVC() {
        for vc in navigationController!.viewControllers {
            if vc is InboundViewController {
                navigationController?.popToViewController(vc, animated: true)
            }
        }
    }
    func popToOutboundVC() {
        for vc in navigationController!.viewControllers {
            if vc is OutBoundViewController {
                navigationController?.popToViewController(vc, animated: true)
            }
        }
    }
}
  
extension DriverSeallnfoViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == txtDriverName {
            txtSealNumber.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
        }
        
        return true
    }
}
