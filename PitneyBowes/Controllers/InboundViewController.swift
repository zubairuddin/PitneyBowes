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
    
    var inboundGeneralInfo: InboundShipmentGeneralInfo?
    var inboundDriverInfo: InboundShipmentDriverInfo?
    
    @IBOutlet weak var imgGeneralInfo: UIImageView!
    @IBOutlet weak var imgDriverInfo: UIImageView!
    @IBOutlet weak var lblRequiredFields: UILabel!
    
    var isGeneralInfoEntered = false
    var isDriverInfoEntered = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavBarImage()
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
    
    func callSaveInboundShipmentAPI() {
    }
    
    @IBAction func Button_Driver(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DriverSeallnfoViewController")as! DriverSeallnfoViewController
        vc.inboundDriverInfoDelegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func submitInboundShipment(_ sender: UIButton) {
        guard let generalInfo = inboundGeneralInfo, let driverInfo = inboundDriverInfo else {
            presentAlert(withTitle: "Required Info Missing.", message: "")
            return
        }
        
        //Call Save inbound shipment API
        guard let userId = ApplicationManager.shared.loggedInUserId else {
            return
        }
        
        SVProgressHUD.show(withStatus: "Submitting...")
        SVProgressHUD.setDefaultMaskType(.black)
        
        APIManager.executeRequest(appendingPath: "shipments/add", withQueryString: "user_id=\(userId)&bol=\(generalInfo.bol)&pro_number=\(generalInfo.proNumber)&carries=\(generalInfo.carrier)&ngs_location=\(generalInfo.ngsLocation)&latitude=\(generalInfo.latitude)&longitude=\(generalInfo.longitude)&origin=\(generalInfo.origin)&state_code=\(generalInfo.state)employee_name=\(generalInfo.employeeName)&driver_name=\(driverInfo.driverName)&seal_number=\(driverInfo.sealNumber)&lock_on_trailer=\(driverInfo.isLockOnTrailer)", httpMethod: "POST") { (data, error) in
            
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
                                self.presentAlert(withTitle: message, message: "")
                            }
                            
                            //Reset data
                            self.inboundGeneralInfo = nil
                            self.inboundDriverInfo = nil
                            
                            self.imgGeneralInfo.isHidden = true
                            self.imgDriverInfo.isHidden = true
                            
                            self.isGeneralInfoEntered = false
                            self.isDriverInfoEntered = false
                            
                        }
                    }
                }
                
                print(json)
            }
                
            catch let error {
                self.hideHud()
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func button_generalInfoPressed(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "GeneralInfoViewController")as! GeneralInfoViewController
        vc.inboundDataReceiverVc = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showHideRequiredFieldsLabel() {
        if isGeneralInfoEntered && isDriverInfoEntered {
            lblRequiredFields.isHidden = true
        }
        else {
            lblRequiredFields.isHidden = false
        }
    }
}


extension InboundViewController: SaveInboundGeneralInfoProtocol {
    func didSaveInboundShipmentGeneralInfo(generalInfo: InboundShipmentGeneralInfo) {
        print("Received general info: \(generalInfo)")
        inboundGeneralInfo = generalInfo
        imgGeneralInfo.isHidden = false
        isGeneralInfoEntered = true
        
        showHideRequiredFieldsLabel()
    }
}

extension InboundViewController: SaveInboundDriverInfoProtocol {
    func didSaveInboundShipmentDriverInfo(driverInfo: InboundShipmentDriverInfo) {
        print("Received driver info: \(driverInfo)")
        inboundDriverInfo = driverInfo
        imgDriverInfo.isHidden = false
        isDriverInfoEntered = true
        
        showHideRequiredFieldsLabel()
    }
}
