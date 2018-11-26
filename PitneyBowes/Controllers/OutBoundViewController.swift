//
//  OutBoundViewController.swift
//  ConstantIpadView
//
//  Created by mac on 15/10/18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit
import SVProgressHUD

class OutBoundViewController: UIViewController {

    @IBOutlet weak var imgGeneralInfo: UIImageView!
    @IBOutlet weak var imgDriverAndSealInfo: UIImageView!
    @IBOutlet weak var imgTractorAndTrailer: UIImageView!
    @IBOutlet weak var imgQuestionaire: UIImageView!
    @IBOutlet weak var btnSavedOutbound: RoundedBorderButton!
    @IBOutlet weak var lblRequiredFields: UILabel!
    
    var savedOutbound: SavedOutbound?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "New DaLI"
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        let CancleButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel,
                                           target: self,
                                           action: #selector(Cancle(_:)))
        self.navigationItem.leftBarButtonItem = CancleButton
        
        //If we are not coming from SavedOutbound screen, then savedOutbound will be nil
        if savedOutbound == nil {
            print("Adding new inbound shipment")
            //savedInbound = SavedInbound(context: MANAGED_OBJECT_CONTEXT)
            btnSavedOutbound.isHidden = false
        }
        else {
            print("Updating the inbound shipment")
            //Hide SavedInbound button
            btnSavedOutbound.isHidden = true
            
            //Logic to show/hide checkmark
            showHideCheckMarkAndLabel()
            //*************************************//
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {

    }

    func showHideCheckMarkAndLabel() {
        if savedOutbound?.generalInfo != nil && savedOutbound?.driverInfo != nil && savedOutbound?.tractorInfo != nil && savedOutbound?.questionnaireInfo != nil {
            imgGeneralInfo.isHidden = false
            imgDriverAndSealInfo.isHidden = false
            imgTractorAndTrailer.isHidden = false
            imgQuestionaire.isHidden = false
            lblRequiredFields.isHidden = true
        }
        else if savedOutbound?.generalInfo != nil && savedOutbound?.driverInfo != nil && savedOutbound?.tractorInfo != nil && savedOutbound?.questionnaireInfo == nil {
            imgGeneralInfo.isHidden = false
            imgDriverAndSealInfo.isHidden = false
            imgTractorAndTrailer.isHidden = false
            imgQuestionaire.isHidden = true
            lblRequiredFields.isHidden = false

        }
        else if savedOutbound?.generalInfo != nil && savedOutbound?.driverInfo != nil && savedOutbound?.tractorInfo == nil && savedOutbound?.questionnaireInfo != nil {
            imgGeneralInfo.isHidden = false
            imgDriverAndSealInfo.isHidden = false
            imgTractorAndTrailer.isHidden = true
            imgQuestionaire.isHidden = false
            lblRequiredFields.isHidden = false
            
        }
        else if savedOutbound?.generalInfo != nil && savedOutbound?.driverInfo == nil && savedOutbound?.tractorInfo != nil && savedOutbound?.questionnaireInfo != nil {
            imgGeneralInfo.isHidden = false
            imgDriverAndSealInfo.isHidden = true
            imgTractorAndTrailer.isHidden = false
            imgQuestionaire.isHidden = false
            lblRequiredFields.isHidden = false
        }
        else if savedOutbound?.generalInfo == nil && savedOutbound?.driverInfo != nil && savedOutbound?.tractorInfo != nil && savedOutbound?.questionnaireInfo != nil {
            imgGeneralInfo.isHidden = true
            imgDriverAndSealInfo.isHidden = false
            imgTractorAndTrailer.isHidden = false
            imgQuestionaire.isHidden = false
            lblRequiredFields.isHidden = false
        }
        else if savedOutbound?.generalInfo == nil && savedOutbound?.driverInfo == nil && savedOutbound?.tractorInfo != nil && savedOutbound?.questionnaireInfo != nil {
            imgGeneralInfo.isHidden = true
            imgDriverAndSealInfo.isHidden = true
            imgTractorAndTrailer.isHidden = false
            imgQuestionaire.isHidden = false
            lblRequiredFields.isHidden = false
        }
        else if savedOutbound?.generalInfo == nil && savedOutbound?.driverInfo != nil && savedOutbound?.tractorInfo == nil && savedOutbound?.questionnaireInfo != nil {
            imgGeneralInfo.isHidden = true
            imgDriverAndSealInfo.isHidden = false
            imgTractorAndTrailer.isHidden = true
            imgQuestionaire.isHidden = false
            lblRequiredFields.isHidden = false
        }
        else if savedOutbound?.generalInfo == nil && savedOutbound?.driverInfo != nil && savedOutbound?.tractorInfo != nil && savedOutbound?.questionnaireInfo == nil {
            imgGeneralInfo.isHidden = true
            imgDriverAndSealInfo.isHidden = false
            imgTractorAndTrailer.isHidden = false
            imgQuestionaire.isHidden = true
            lblRequiredFields.isHidden = false
        }
        else if savedOutbound?.generalInfo != nil && savedOutbound?.driverInfo == nil && savedOutbound?.tractorInfo == nil && savedOutbound?.questionnaireInfo != nil {
            imgGeneralInfo.isHidden = false
            imgDriverAndSealInfo.isHidden = true
            imgTractorAndTrailer.isHidden = true
            imgQuestionaire.isHidden = false
            lblRequiredFields.isHidden = false
        }
        else if savedOutbound?.generalInfo != nil && savedOutbound?.driverInfo == nil && savedOutbound?.tractorInfo != nil && savedOutbound?.questionnaireInfo == nil {
            imgGeneralInfo.isHidden = false
            imgDriverAndSealInfo.isHidden = true
            imgTractorAndTrailer.isHidden = false
            imgQuestionaire.isHidden = true
            lblRequiredFields.isHidden = false
        }
        else if savedOutbound?.generalInfo != nil && savedOutbound?.driverInfo != nil && savedOutbound?.tractorInfo == nil && savedOutbound?.questionnaireInfo == nil {
            imgGeneralInfo.isHidden = false
            imgDriverAndSealInfo.isHidden = false
            imgTractorAndTrailer.isHidden = true
            imgQuestionaire.isHidden = true
            lblRequiredFields.isHidden = false
        }
        else if savedOutbound?.generalInfo == nil && savedOutbound?.driverInfo == nil && savedOutbound?.tractorInfo == nil && savedOutbound?.questionnaireInfo != nil {
            imgGeneralInfo.isHidden = true
            imgDriverAndSealInfo.isHidden = true
            imgTractorAndTrailer.isHidden = true
            imgQuestionaire.isHidden = false
            lblRequiredFields.isHidden = false
        }
        else if savedOutbound?.generalInfo == nil && savedOutbound?.driverInfo == nil && savedOutbound?.tractorInfo == nil && savedOutbound?.questionnaireInfo == nil {
            imgGeneralInfo.isHidden = true
            imgDriverAndSealInfo.isHidden = true
            imgTractorAndTrailer.isHidden = true
            imgQuestionaire.isHidden = true
            lblRequiredFields.isHidden = false
        }
        else if savedOutbound?.generalInfo != nil && savedOutbound?.driverInfo == nil && savedOutbound?.tractorInfo == nil && savedOutbound?.questionnaireInfo == nil {
            imgGeneralInfo.isHidden = false
            imgDriverAndSealInfo.isHidden = true
            imgTractorAndTrailer.isHidden = true
            imgQuestionaire.isHidden = true
            lblRequiredFields.isHidden = false
        }
    }
    
    @objc func Cancle(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    
    }
    
    @IBAction func generalInfo_pressed(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "GeneralInfoViewController")as! GeneralInfoViewController
        vc.outboundDataReceiverVc = self
        
        if let info = savedOutbound?.generalInfo {
            vc.outboundGeneralInfo = info
        }
        self.navigationController?.pushViewController(vc, animated: true)

    }
    @IBAction func driver_pressed(){
        
        if savedOutbound == nil {
            showGeneralInfoMissingAlert()
            return
        }
        
        let vc  = storyboard?.instantiateViewController(withIdentifier: "DriverSeallnfoViewController") as! DriverSeallnfoViewController
        vc.outboundDriverInfoDelegate = self
        
        if let info = savedOutbound?.driverInfo {
            vc.outboundDriverAndSealInfo = info
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func tractorAndTrailor_pressed(){
        
        if savedOutbound == nil {
            showGeneralInfoMissingAlert()
            return
        }

        let vc  = storyboard?.instantiateViewController(withIdentifier: "TractorandTrailerViewController") as! TractorandTrailerViewController
        vc.outboundTractorInfoDelegate = self
        
        if let info = savedOutbound?.tractorInfo {
            vc.tractorAndTrailerInfo = info
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func securityQue_pressed(){
        
        if savedOutbound == nil {
            showGeneralInfoMissingAlert()
            return
        }

        let vc  = storyboard?.instantiateViewController(withIdentifier: "SecurityQuesionViewController") as! SecurityQuesionViewController
        vc.outboundQuestionaireDelegate = self
        
        if let info = savedOutbound?.questionnaireInfo {
            vc.questionnaireInfo = info
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func savedOutboundTapped(_ sender: RoundedBorderButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SavedShipmentViewController") as! SavedShipmentViewController
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func submitOutboundInfo() {
        guard let generalInfo = savedOutbound?.generalInfo, let driverInfo = savedOutbound?.driverInfo, let tractorInfo = savedOutbound?.tractorInfo, let questionaireInfo = savedOutbound?.questionnaireInfo else {
            presentAlert(withTitle: "Required Info Missing.", message: "")
            return
        }

        guard let userID = ApplicationManager.shared.loggedInUserId, let type = ApplicationManager.shared.shipmentType else {
            return
        }
        
        SVProgressHUD.show(withStatus: "Submitting...")
        SVProgressHUD.setDefaultMaskType(.black)
        
        //Get the stored images and send them in form data
        var params = [[String:UIImage]]()
        
        let tractorImages = savedOutbound?.tractorInfo?.images as! [[String:UIImage]]
        let driverImages = savedOutbound?.driverInfo?.images as! [[String:UIImage]]
        let signatureImage = savedOutbound?.questionnaireInfo?.signature as! [String:UIImage]
        
        
        //append tractor and trailer images
        for tractorImage in tractorImages {
            params.append(tractorImage)
        }
        
        for driverImage in driverImages {
            params.append(driverImage)
        }

        //append the signature image
        params.append(signatureImage)
        
        print("Form data parameters are: \(params)")
        
        APIManager.saveOutboundInfo(appendingPath: "shipments/add", withQueryString: "user_id=\(userID)&type=\(type)&bol=\(generalInfo.bolNumber)&pro_number=\(generalInfo.proNumber)&carrier=\(generalInfo.carrier)&ngs_location=\(generalInfo.ngsLocation)&latitude=\(generalInfo.latitude)&longitude=\(generalInfo.longitude)&destination=\(generalInfo.destination)&state_code=\(generalInfo.stateCode)&employee_name=\(generalInfo.employeeName)&driver_name=\(driverInfo.driverName)&seal_number=\(driverInfo.sealNumber)&lock_on_trailer=\(driverInfo.lockOnTrailer)&trailer_number=\(tractorInfo.trailerNumber)&tractor_dot_number=\(tractorInfo.tractorDotNumber)&tractor_plate=\(tractorInfo.tractorPlate)&dont_discuss_shipment=\(questionaireInfo.discussShipment)&dont_carry_passengers=\(questionaireInfo.carryPassengers)&acknowledge_receipt=\(questionaireInfo.receiptAcknowledge)&alert_contact=\(questionaireInfo.alertContact)&cdl_number=\(driverInfo.cdlNumber ?? "")&cdl_expiry_date=\(driverInfo.expirationDate ?? "")&trailer_license_plate_state=\(tractorInfo.trailerPlateState)", paramerer: params) { (data, error) in
            
            if error != nil {
                print(error!.localizedDescription)
                
                self.hideHud()
                return
            }
            
            guard let responseData = data else {
                self.hideHud()
                return
            }
            
            do {
                self.hideHud()
                guard let json = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as? [String:Any] else {
                    return
                }
                
                print(json)
                
                
                if let error = json["error"] as? Int {
                    if error == 0 {
                        
                        DispatchQueue.main.async {
                            if let message = json["message"] as? String {
                                //self.presentAlert(withTitle: message, message: "")
                                
                                let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
                                let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                    //Remove the saved outbound from Core Data
                                    KAPPDELEGATE.persistentContainer.viewContext.delete(self.savedOutbound!)
                                    do {
                                        try KAPPDELEGATE.persistentContainer.viewContext.save()
                                        print("Deleted successfully")
                                        self.showHideCheckMarkAndLabel()
                                        self.savedOutbound = nil
                                        self.popToMainVC()
                                    }
                                    catch let error {
                                        print("Unable to delete saved outbound: \(error.localizedDescription)")
                                    }
                                })
                                
                                alert.addAction(okAction)
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                    }
                }
            }
            catch let error {
                self.hideHud()
                print(error.localizedDescription)
            }
        }
    }
    
}

extension OutBoundViewController: SaveOutboundGeneralInfoProtocol {
    func didSaveOutboundShipmentGeneralInfo(generalInfo: OutboundShipmentGeneralInfo) {
        print("Outbound shipment general info: \(generalInfo)")
        
        //Save in core data
        let outboundGeneralInfo = OutboundGeneralInfo(context: MANAGED_OBJECT_CONTEXT)
        outboundGeneralInfo.bolNumber = generalInfo.bol
        outboundGeneralInfo.proNumber = generalInfo.proNumber
        outboundGeneralInfo.carrier = generalInfo.carrier
        outboundGeneralInfo.employeeName = generalInfo.employeeName
        outboundGeneralInfo.destination = generalInfo.destination
        outboundGeneralInfo.ngsLocation = generalInfo.ngsLocation
        outboundGeneralInfo.latitude = generalInfo.latitude
        outboundGeneralInfo.longitude = generalInfo.longitude
        outboundGeneralInfo.stateCode = generalInfo.state
        outboundGeneralInfo.sealNumber = generalInfo.sealNumber
        
        if let saved = savedOutbound {
            //If a saved outbound exists, update it's general info
            saved.generalInfo = outboundGeneralInfo
        }
        else {
            //else create a new instance of SavedOutbound and set it's general info
            savedOutbound = SavedOutbound(context: MANAGED_OBJECT_CONTEXT)
            savedOutbound?.generalInfo = outboundGeneralInfo
        }
        
        do {
            try MANAGED_OBJECT_CONTEXT.save()
            showHideCheckMarkAndLabel()
        }
            
        catch let error {
            print("Unable to save outbound shipment general info in core data: \(error.localizedDescription)")
        }
    }
}

extension OutBoundViewController: SaveOutboundDriverInfoProtocol {
    func didSaveOutboundShipmentDriverInfo(driverInfo: OutboundShipmentDriverInfo) {
        print("Outbound shipment driver info: \(driverInfo)")
        
        //Save in core data
        let outboundDriverInfo = OutboundDriverInfo(context: MANAGED_OBJECT_CONTEXT)
        outboundDriverInfo.driverName = driverInfo.driverName
        outboundDriverInfo.sealNumber = driverInfo.sealNumber
        outboundDriverInfo.lockOnTrailer = driverInfo.isLockOnTrailer
        outboundDriverInfo.cdlNumber = driverInfo.cdlNumber
        outboundDriverInfo.expirationDate = driverInfo.expirationDate
        outboundDriverInfo.images = driverInfo.driverImages as NSObject
        
        //Need to confirm what will be displayed on the grid/list if user enters driver info before entering general info,
        
        //Only save driver info if general info is already available
        if let outbound = savedOutbound {
            outbound.driverInfo = outboundDriverInfo
            
            do{
                try MANAGED_OBJECT_CONTEXT.save()
                showHideCheckMarkAndLabel()
            }
            catch let error {
                print("Unable to save inbound shipment driver info in core data: \(error.localizedDescription)")
            }
        }
            
        else {
            //Commented because currently we are not allowing driver info to be entered if general info is missing. This is because on saved inbound grid we are displaying each outbound by it's BOL number and we can not display the bol number unless the general info is entered
            
            //If however we need to rollback this change, just uncomment the below two lines, remove the alert code and move the code to save managed object context outside of the upper if block.
            
//            savedOutbound = SavedOutbound(context: MANAGED_OBJECT_CONTEXT)
//            savedOutbound?.driverInfo = outboundDriverInfo

        }
    }
}

extension OutBoundViewController: SaveOutboundTractorAndTrailerInfoProtocol {
    func didSaveTractorAndTrailerInfo(tractorAndTrailerInfo: OutboundShipmentTractorInfo) {
        print("Tractor and trailer info: \(tractorAndTrailerInfo)")
        
        let tractorInfo = OutboundTractorInfo(context: MANAGED_OBJECT_CONTEXT)
        tractorInfo.tractorPlate = tractorAndTrailerInfo.tractorPlate
        tractorInfo.tractorDotNumber = tractorAndTrailerInfo.tractorDotNumber
        tractorInfo.trailerNumber = tractorAndTrailerInfo.trailerNumber
        tractorInfo.lockOnTrailer = tractorAndTrailerInfo.lockOnTrailer
        tractorInfo.trailerPlateState = tractorAndTrailerInfo.trailerPlateAndState
        
        //Images are stored as transformable, so we have to convert them as NSObject
        tractorInfo.images = tractorAndTrailerInfo.tractorAndTrailerImages as NSObject
        
        //Check if savedOutbound exists or not
        if let outbound = savedOutbound {
            outbound.tractorInfo = tractorInfo
            
            do {
                try MANAGED_OBJECT_CONTEXT.save()
                showHideCheckMarkAndLabel()
            }
            catch let error {
                print("Unable to save tractor info: \(error.localizedDescription)")
            }
        }
            
        else {
            //Commented because currently we are not allowing driver info to be entered if general info is missing. This is because on saved inbound grid we are displaying each outbound by it's BOL number and we can not display the bol number unless the general info is entered
            
            //If however we need to rollback this change, just uncomment the below two lines, remove the alert code and move the code to save managed object context outside of the upper if block.

//            savedOutbound = SavedOutbound(context: MANAGED_OBJECT_CONTEXT)
//            savedOutbound?.tractorInfo = tractorInfo
            
            //showGeneralInfoMissingAlert()
        }

    }
}
extension OutBoundViewController: SaveOutboundQuestionaireProtocol {
    func didSaveQuestionaireInfo(questionaireInfo: OutboundShipmentQuestionaireInfo) {
        print("Questionaire info: \(questionaireInfo)")
        
        let outboundQuestionnaireInfo = OutboundQuestionnaireInfo(context: MANAGED_OBJECT_CONTEXT)
        outboundQuestionnaireInfo.carryPassengers = questionaireInfo.carryPassengers
        outboundQuestionnaireInfo.alertContact = questionaireInfo.alertContact
        outboundQuestionnaireInfo.discussShipment = questionaireInfo.discussShipment
        outboundQuestionnaireInfo.receiptAcknowledge = questionaireInfo.acknowledgeReceipt
        
        //signature property is Transformable type, so we have to convert it to NSObject
        outboundQuestionnaireInfo.signature = questionaireInfo.signature as NSObject
        
        //check if outbound exists
        if let outbound = savedOutbound {
            outbound.questionnaireInfo = outboundQuestionnaireInfo
            
            do {
                try MANAGED_OBJECT_CONTEXT.save()
                showHideCheckMarkAndLabel()
            }
            catch let error {
                print("Unable to save tractor info: \(error.localizedDescription)")
            }

        }
        else {
            //Commented because currently we are not allowing driver info to be entered if general info is missing. This is because on saved inbound grid we are displaying each outbound by it's BOL number and we can not display the bol number unless the general info is entered
            
            //If however we need to rollback this change, just uncomment the below two lines, remove the alert code and move the code to save managed object context outside of the upper if block.

//            savedOutbound = SavedOutbound(context: MANAGED_OBJECT_CONTEXT)
//            savedOutbound?.questionnaireInfo = outboundQuestionnaireInfo
            
            //showGeneralInfoMissingAlert()
        }
    }
}

