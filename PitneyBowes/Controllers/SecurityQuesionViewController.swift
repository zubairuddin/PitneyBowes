//
//  ElevanViewController.swift
//  ConstantIpadView
//
//  Created by mac on 15/10/18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit
import YPDrawSignatureView

struct OutboundShipmentQuestionaireInfo {
    let discussShipment: Bool
    let carryPassengers: Bool
    let acknowledgeReceipt: Bool
    let alertContact: Bool
    let signature: [String:UIImage]?
}

protocol SaveOutboundQuestionaireProtocol {
    func didSaveQuestionaireInfo(questionaireInfo: OutboundShipmentQuestionaireInfo)
}

class SecurityQuesionViewController: UIViewController {

    @IBOutlet weak var btnClearSignature: RoundedBorderButton!
    @IBOutlet weak var viewDrawSignature: YPDrawSignatureView!
    @IBOutlet weak var lblSignature: UILabel!
    
    var outboundQuestionaireDelegate: SaveOutboundQuestionaireProtocol?
    
    var isDiscussShipment = false
    var isCarryPassengers = false
    var isAcknowledgeReceipt = false
    var isAlertContact = false
    var signature: [String:UIImage]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Security Questionnaire"
        
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveQuestionaireInfo))
        navigationItem.rightBarButtonItem = saveButton
        
        viewDrawSignature.layer.borderColor = btnClearSignature.currentTitleColor.cgColor
        viewDrawSignature.layer.borderWidth = 2
        viewDrawSignature.layer.masksToBounds = true
    }

    @IBAction func answerSelected(_ sender: UISwitch) {
        switch sender.tag {
        case 1:
            //discuss Shipment
            isDiscussShipment = sender.isOn ? true : false
        case 2:
            //carry passengers
            isCarryPassengers = sender.isOn ? true : false
        case 3:
            //acknowledge receipt
            isAcknowledgeReceipt = sender.isOn ? true : false
        case 4:
            //alert contact
            isAlertContact = sender.isOn ? true : false
        default:
            break
        }
    }
    @IBAction func clearSignature(_ sender: RoundedBorderButton) {
        viewDrawSignature.clear()
    }
    
    @objc func saveQuestionaireInfo() {

        guard let signatureImage = viewDrawSignature.getSignature() else {
            presentAlert(withTitle: "Please provide your signature.", message: "")
            return
        }
        
        signature = ["signature": signatureImage]
        
        guard let sign = signature else {
            presentAlert(withTitle: "Unable to get image from signature.", message: "")
            return
        }
        
        let info = OutboundShipmentQuestionaireInfo(discussShipment: isDiscussShipment, carryPassengers: isCarryPassengers, acknowledgeReceipt: isAcknowledgeReceipt, alertContact: isAlertContact, signature: sign)
        
        outboundQuestionaireDelegate?.didSaveQuestionaireInfo(questionaireInfo: info)
        
        navigationController?.popViewController(animated: true)
    }
    
}

