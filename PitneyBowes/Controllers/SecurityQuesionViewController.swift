//
//  ElevanViewController.swift
//  ConstantIpadView
//
//  Created by mac on 15/10/18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit

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

    @IBOutlet weak var imgSignature: UIImageView!
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
    @IBAction func takeSignatureAction(_ sender: RoundedBorderButton) {
        let alert = UIAlertController(title: "Select Image", message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.openCamera()
        }
        let galleryAction = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            self.openPhotoLibrary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        }
        
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        
        //iPad specific lines
        alert.popoverPresentationController?.sourceView = lblSignature
        alert.popoverPresentationController?.sourceRect = lblSignature.bounds
        alert.popoverPresentationController?.permittedArrowDirections = [.up]
        
        present(alert, animated: true, completion: nil)

    }
    
    @objc func saveQuestionaireInfo() {
        
        guard let sign = signature else {
            presentAlert(withTitle: "Please provide signature.", message: "")
            return
        }
        
        let info = OutboundShipmentQuestionaireInfo(discussShipment: isDiscussShipment, carryPassengers: isCarryPassengers, acknowledgeReceipt: isAcknowledgeReceipt, alertContact: isAlertContact, signature: sign)
        
        outboundQuestionaireDelegate?.didSaveQuestionaireInfo(questionaireInfo: info)
        
        navigationController?.popViewController(animated: true)
    }
    private func openCamera() {
        //Instantiate UIImagePickerController
        let picker = UIImagePickerController()
        picker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            //Show UIImagePicker with Camera
            picker.sourceType = .camera
            present(picker, animated: true, completion: nil)
        }
        else {
            //Show Alert
            let alert  = UIAlertController(title: "Warning", message: "Camera not available", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func openPhotoLibrary() {
        //Instantiate UIImagePickerController
        let picker = UIImagePickerController()
        picker.delegate = self
        //picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }

}

extension SecurityQuesionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }
        
        imgSignature.image = selectedImage
        
        signature = ["signature": selectedImage]
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

