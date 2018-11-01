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

    var outboundGeneralInfo: OutboundShipmentGeneralInfo?
    var outboundDriverInfo: OutboundShipmentDriverInfo?
    var outboundTractorAndTrailerInfo: OutboundShipmentTractorInfo?
    var outboundQuestionaireInfo: OutboundShipmentQuestionaireInfo?

    @IBOutlet weak var imgGeneralInfo: UIImageView!
    @IBOutlet weak var imgDriverAndSealInfo: UIImageView!
    @IBOutlet weak var imgTractorAndTrailer: UIImageView!
    @IBOutlet weak var imgQuestionaire: UIImageView!
    
    @IBOutlet weak var lblRequiredFields: UILabel!
    var isGeneralInfoEntered = false
    var isDriverInfoEntered = false
    var isTractorAndTrailerInfoEntered = false
    var isQuestionnaireInfoEntered = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "New DaL!"
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        let CancleButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel,
                                           target: self,
                                           action: #selector(Cancle(_:)))
        self.navigationItem.leftBarButtonItem = CancleButton
    }

    @objc func Cancle(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    
    }
    
    @IBAction func generalInfo_pressed(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "GeneralInfoViewController")as! GeneralInfoViewController
        vc.outboundDataReceiverVc = self
        self.navigationController?.pushViewController(vc, animated: true)

    }
    @IBAction func driver_pressed(){
        let vc  = storyboard?.instantiateViewController(withIdentifier: "DriverSeallnfoViewController") as! DriverSeallnfoViewController
        vc.outboundDriverInfoDelegate = self
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func tractorAndTrailor_pressed(){
        let vc  = storyboard?.instantiateViewController(withIdentifier: "TractorandTrailerViewController") as! TractorandTrailerViewController
        vc.outboundTractorInfoDelegate = self
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func securityQue_pressed(){
        let vc  = storyboard?.instantiateViewController(withIdentifier: "SecurityQuesionViewController") as! SecurityQuesionViewController
        vc.outboundQuestionaireDelegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func submitOutboundInfo() {
        guard let generalInfo = outboundGeneralInfo, let driverInfo = outboundDriverInfo, let tractorInfo = outboundTractorAndTrailerInfo, let questionaireInfo = outboundQuestionaireInfo else {
            presentAlert(withTitle: "Required Info Missing.", message: "")
            return
        }

        guard let userID = ApplicationManager.shared.loggedInUserId, let type = ApplicationManager.shared.shipmentType else {
            return
        }
        
        SVProgressHUD.show(withStatus: "Submitting...")
        SVProgressHUD.setDefaultMaskType(.black)
        
        var params = tractorInfo.tractorAndTrailerImages
        params.append(questionaireInfo.signature!)
        
        print("Form data parameters are: \(params)")
        
        APIManager.saveOutboundInfo(appendingPath: "shipments/add", withQueryString: "user_id=\(userID)&type=\(type)&bol=\(generalInfo.bol)&pro_number=\(generalInfo.proNumber)&carrier=\(generalInfo.carrier)&ngs_location=\(generalInfo.ngsLocation)&latitude=\(generalInfo.latitude)&longitude=\(generalInfo.longitude)&origin=\(generalInfo.destination)&state_code=\(generalInfo.state)&employee_name=\(generalInfo.employeeName)&driver_name=\(driverInfo.driverName)&seal_number=\(driverInfo.sealNumber)&lock_on_trailer=\(driverInfo.isLockOnTrailer)&trailer_number=\(tractorInfo.trailerNumber)&tractor_dot_number=\(tractorInfo.tractorDotNumber)&tractor_plate=\(tractorInfo.tractorPlate)&dont_discuss_shipment=\(questionaireInfo.discussShipment)&dont_carry_passengers=\(questionaireInfo.carryPassengers)&acknowledge_receipt=\(questionaireInfo.acknowledgeReceipt)&alert_contact=\(questionaireInfo.alertContact)", paramerer: params) { (data, error) in
            
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
                                self.presentAlert(withTitle: message, message: "")
                            }
                            
                            //Reset data
                            self.outboundGeneralInfo = nil
                            self.outboundDriverInfo = nil
                            self.outboundTractorAndTrailerInfo = nil
                            self.outboundQuestionaireInfo = nil

                            self.imgGeneralInfo.isHidden = true
                            self.imgDriverAndSealInfo.isHidden = true
                            self.imgTractorAndTrailer.isHidden = true
                            self.imgQuestionaire.isHidden = true
                            
                            self.isGeneralInfoEntered = false
                            self.isDriverInfoEntered = false
                            self.isTractorAndTrailerInfoEntered = false
                            self.isQuestionnaireInfoEntered = false
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
    
    func showHideRequiredFieldsLabel() {
        if isGeneralInfoEntered && isDriverInfoEntered && isTractorAndTrailerInfoEntered && isQuestionnaireInfoEntered {
            lblRequiredFields.isHidden = true
        }
        else {
            lblRequiredFields.isHidden = false
        }
    }
}

extension OutBoundViewController: SaveOutboundGeneralInfoProtocol {
    func didSaveOutboundShipmentGeneralInfo(generalInfo: OutboundShipmentGeneralInfo) {
        print("Outbound shipment general info: \(generalInfo)")
        outboundGeneralInfo = generalInfo
        imgGeneralInfo.isHidden = false
        isGeneralInfoEntered = true
        showHideRequiredFieldsLabel()
    }
}

extension OutBoundViewController: SaveOutboundDriverInfoProtocol {
    func didSaveOutboundShipmentDriverInfo(driverInfo: OutboundShipmentDriverInfo) {
        print("Outbound shipment driver info: \(driverInfo)")
        outboundDriverInfo = driverInfo
        imgDriverAndSealInfo.isHidden = false
        isDriverInfoEntered = true
        showHideRequiredFieldsLabel()
    }
}

extension OutBoundViewController: SaveOutboundTractorAndTrailerInfoProtocol {
    func didSaveTractorAndTrailerInfo(tractorAndTrailerInfo: OutboundShipmentTractorInfo) {
        print("Tractor and trailer info: \(tractorAndTrailerInfo)")
        outboundTractorAndTrailerInfo = tractorAndTrailerInfo
        imgTractorAndTrailer.isHidden = false
        isTractorAndTrailerInfoEntered = true
        showHideRequiredFieldsLabel()
    }
}
extension OutBoundViewController: SaveOutboundQuestionaireProtocol {
    func didSaveQuestionaireInfo(questionaireInfo: OutboundShipmentQuestionaireInfo) {
        print("Questionaire info: \(questionaireInfo)")
        outboundQuestionaireInfo = questionaireInfo
        imgQuestionaire.isHidden = false
        isQuestionnaireInfoEntered = true
        showHideRequiredFieldsLabel()
    }
}

