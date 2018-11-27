//
//  ViewController.swift
//  ConstantIpadView
//
//  Created by mac on 11/10/18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit
import SVProgressHUD

class InboundViewController : UIViewController {

    @IBOutlet weak var imgGeneralInfo: UIImageView!
    @IBOutlet weak var imgDriverInfo: UIImageView!
    @IBOutlet weak var lblRequiredFields: UILabel!
    @IBOutlet weak var btnSavedInbound: RoundedBorderButton!
    
    var savedInbound: SavedInbound?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavBarImage()
        
        //If we are not coming from SavedInbound screen, then savedInbound will be nil
        if savedInbound == nil {
            print("Adding new inbound shipment")
            //savedInbound = SavedInbound(context: MANAGED_OBJECT_CONTEXT)
            btnSavedInbound.isHidden = false
        }
        else {
            print("Updating the inbound shipment")
            //Hide SavedInbound button
            btnSavedInbound.isHidden = true
            
            //Logic to show/hide checkmark
            showHideCheckMarkAndLabel()
            //*************************************//
        }

    }

    override func viewWillAppear(_ animated: Bool) {

    }
    
    func showHideCheckMarkAndLabel() {
        if savedInbound?.generalInfo != nil && savedInbound?.driverInfo != nil{
            imgGeneralInfo.isHidden = false
            imgDriverInfo.isHidden = false
            lblRequiredFields.isHidden = true
        }
        else if savedInbound?.generalInfo != nil && savedInbound?.driverInfo == nil {
            imgGeneralInfo.isHidden = false
            imgDriverInfo.isHidden = true
            lblRequiredFields.isHidden = false
            
        }
        else if savedInbound?.generalInfo == nil && savedInbound?.driverInfo != nil {
            imgGeneralInfo.isHidden = true
            imgDriverInfo.isHidden = false
            lblRequiredFields.isHidden = false
        }
        else if savedInbound?.generalInfo == nil && savedInbound?.driverInfo == nil {
            imgGeneralInfo.isHidden = true
            imgDriverInfo.isHidden = true
            lblRequiredFields.isHidden = false
        }
    }
    
    
    func addNavBarImage() {
        
        let navController = navigationController!
        
        let image = UIImage(named: "pb-new-logo.png") //Your logo url here
        let imageView = UIImageView(image: image)
        
        let bannerWidth = navController.navigationBar.frame.size.width
        let bannerHeight = navController.navigationBar.frame.size.height
        
        let bannerX = bannerWidth / 2 - (image?.size.width)! / 2
        let bannerY = bannerHeight / 2 - (image?.size.height)! / 2
        
        imageView.frame = CGRect(x: bannerX, y: bannerY, width: bannerWidth, height: bannerHeight)
        imageView.contentMode = .scaleAspectFit
        
        navigationItem.titleView = imageView
    }
    
    @IBAction func button_generalInfoPressed(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "GeneralInfoViewController")as! GeneralInfoViewController
        vc.inboundDataReceiverVc = self
        
        //Check if general info available for saved inbound
        if let info = savedInbound?.generalInfo {
            vc.inboundGeneralInfo = info
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func Button_Driver(_ sender: UIButton) {
        
        if savedInbound == nil {
            showGeneralInfoMissingAlert()
            return
        }

        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DriverSeallnfoViewController")as! DriverSeallnfoViewController
        vc.inboundDriverInfoDelegate = self
        
        //Check if driver info available for saved inbound
        if let info = savedInbound?.driverInfo {
            vc.inboundDriverAndSealInfo = info
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func savedInboundTapped(_ sender: RoundedBorderButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SavedShipmentViewController") as! SavedShipmentViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func submitInboundShipment(_ sender: UIButton) {
        
        guard let generalInfo = savedInbound?.generalInfo, let driverInfo = savedInbound?.driverInfo else {
            presentAlert(withTitle: "Required Info Missing.", message: "")
            return
        }
        
        //Call Save inbound shipment API
        guard let userId = ApplicationManager.shared.loggedInUserId else {
            return
        }
        
        SVProgressHUD.show(withStatus: "Submitting...")
        SVProgressHUD.setDefaultMaskType(.black)
        
        //Get the bol, pro, and origin array
        let bolProdetails = generalInfo.bolAndProdetails as! [BolProOrigin]
        
        //Get the first object of each of them to save in mandatory fields
        let firstBol = bolProdetails[0].bol
        let firstPro = bolProdetails[0].proNumber
        let firstOrigin = bolProdetails[0].origin
        
        print("\(firstBol) \(firstPro) \(firstOrigin)")

        //TODO: Remove extra entry for optional param
        var strOptionalParams = ""
        for i in 1..<bolProdetails.count {
            let optionalIndex = "optional[\(i)]"
            strOptionalParams += "\(optionalIndex)[bol]=\(bolProdetails[i].bol ?? "")&\(optionalIndex)[pro_number]=\(bolProdetails[i].proNumber ?? "")&\(optionalIndex)[origin]=\(bolProdetails[i].origin ?? "")"
            
            if i < bolProdetails.count - 1 {
                strOptionalParams += "&"
            }
        }
        
        APIManager.executeRequest(appendingPath: "shipments/add", withQueryString: "user_id=\(userId)&bol=\(firstBol!)&pro_number=\(firstPro!)&carrier=\(generalInfo.carrier)&ngs_location=\(generalInfo.ngsLocation)&latitude=\(generalInfo.latitude)&longitude=\(generalInfo.longitude)&origin=\(firstOrigin!)&state_code=\(generalInfo.stateCode)&employee_name=\(generalInfo.employeeName)&driver_name=\(driverInfo.driverName)&seal_number=\(driverInfo.sealNumber)&lock_on_trailer=\(driverInfo.lockOnTrailer)&shipment_brokered=\(generalInfo.isShipmentBrokered ?? "")&brokered_by=\(generalInfo.brokeredBy ?? "")&\(strOptionalParams)", httpMethod: "POST") { (data, error) in

            if error != nil {
                print("Error while adding inbound shipment : \(error!.localizedDescription)")
                self.hideHud()
                return
            }

            guard let responseData = data else {
                self.hideHud()
                return
            }

            do {
                guard let json = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as? [String:Any] else {

                    DispatchQueue.main.async {
                        SVProgressHUD.dismiss()
                        self.presentAlert(withTitle: "An error occured while saving inbound shipment.", message: "")
                    }

                    return
                }

                self.hideHud()
                if let error = json["error"] as? Int {
                    if error == 0 {

                        DispatchQueue.main.async {
                            if let message = json["message"] as? String {
                                //self.presentAlert(withTitle: message, message: "")

                                let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
                                let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                    //Remove the saved inbound from Core Data
                                    KAPPDELEGATE.persistentContainer.viewContext.delete(self.savedInbound!)
                                    do {
                                        try KAPPDELEGATE.persistentContainer.viewContext.save()
                                        print("Deleted successfully")
                                        self.showHideCheckMarkAndLabel()
                                        self.savedInbound = nil
                                        //self.navigationController?.popViewController(animated: true)
                                        self.popToMainVC()
                                    }
                                    catch let error {
                                        print("Unable to delete saved inbound: \(error.localizedDescription)")
                                    }
                                })

                                alert.addAction(okAction)
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                    }
                }

               // print(json)
            }

            catch let error {
                self.hideHud()
                print(error.localizedDescription)
            }
        }
    }
}


extension InboundViewController: SaveInboundGeneralInfoProtocol {
    func didSaveInboundShipmentGeneralInfo(generalInfo: InboundShipmentGeneralInfo) {
        print("Received general info: \(generalInfo)")
        
        //Save in core data
        let inboundShipmentInfo = InboundGeneralInfo(context: MANAGED_OBJECT_CONTEXT)

        inboundShipmentInfo.bolAndProdetails = generalInfo.bolProdetails as NSObject
        inboundShipmentInfo.carrier = generalInfo.carrier
        inboundShipmentInfo.employeeName = generalInfo.employeeName
        inboundShipmentInfo.ngsLocation = generalInfo.ngsLocation
        inboundShipmentInfo.latitude = generalInfo.latitude
        inboundShipmentInfo.longitude = generalInfo.longitude
        inboundShipmentInfo.stateCode = generalInfo.state
        inboundShipmentInfo.isShipmentBrokered = generalInfo.isShipmentBrokered
        inboundShipmentInfo.brokeredBy = generalInfo.brokeredBy
        
        if let saved = savedInbound {
            //If a saved inbound exists, update it's general info
            saved.generalInfo = inboundShipmentInfo
        }
            
        else {
            //else create a new instance of SavedInbound and set it's general info
            savedInbound = SavedInbound(context: MANAGED_OBJECT_CONTEXT)
            savedInbound?.generalInfo = inboundShipmentInfo
        }
        
        do {
            try MANAGED_OBJECT_CONTEXT.save()
            print("Saved Inbound General Info successfully")
            showHideCheckMarkAndLabel()
        }
            
        catch let error {
            print("Unable to save inbound shipment general info in core data: \(error.localizedDescription)")
        }
    }
}

extension InboundViewController: SaveInboundDriverInfoProtocol {
    func didSaveInboundShipmentDriverInfo(driverInfo: InboundShipmentDriverInfo) {
        print("Received driver info: \(driverInfo)")
        //Save in core data
        let inboundShipmentDriverInfo = InboundDriverInfo(context: MANAGED_OBJECT_CONTEXT)
        inboundShipmentDriverInfo.driverName = driverInfo.driverName
        inboundShipmentDriverInfo.sealNumber = driverInfo.sealNumber
        inboundShipmentDriverInfo.lockOnTrailer = driverInfo.isLockOnTrailer
        
        //Need to confirm what will be displayed on the grid/list if user enters driver info before entering general info,
        
        //Only save driver info if general info is already available
        if let inbound = savedInbound {
            inbound.driverInfo = inboundShipmentDriverInfo
            
            do{
                try MANAGED_OBJECT_CONTEXT.save()
                showHideCheckMarkAndLabel()
            }
            catch let error {
                print("Unable to save inbound shipment driver info in core data: \(error.localizedDescription)")
            }
        }
            
        else {
            
            //Commented because currently we are not allowing driver info to be entered if general info is missing. This is because on saved inbound grid we are displaying each inbound by it's BOL number and we can not display the bol number unless the general info is entered
            
            //If however we need to rollback this change, just uncomment the below two lines, remove the alert code and move the code to save managed object context outside of the upper if block.
            
//            savedInbound = SavedInbound(context: MANAGED_OBJECT_CONTEXT)
//            savedInbound?.driverInfo = inboundShipmentDriverInfo
            
            //Show General Info missing alert
            //showGeneralInfoMissingAlert()
        }
        
    }
}
