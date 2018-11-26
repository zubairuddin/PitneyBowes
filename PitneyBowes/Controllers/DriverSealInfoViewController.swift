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

enum ImageType {
    case driver1, driver2, photoId, other
}

struct OutboundShipmentDriverInfo {
    var driverName: String
    var sealNumber: String
    var isLockOnTrailer: String
    var cdlNumber: String
    var expirationDate: String
    let driverImages : [[String:UIImage]]

}

protocol SaveInboundDriverInfoProtocol {
    func didSaveInboundShipmentDriverInfo(driverInfo: InboundShipmentDriverInfo)
}

protocol SaveOutboundDriverInfoProtocol {
    func didSaveOutboundShipmentDriverInfo(driverInfo: OutboundShipmentDriverInfo)
}

class DriverSeallnfoViewController: UIViewController {

    @IBOutlet weak var viewCDLHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewDatePickerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewCDL: UIView!
    @IBOutlet weak var viewDatePicker: UIView!
    @IBOutlet weak var pickerExpirationDate: UIDatePicker!
    @IBOutlet weak var txtDriverName: UITextField!
    @IBOutlet weak var txtSealNumber: UITextField!
    @IBOutlet weak var segmentIsLock: UISegmentedControl!
    @IBOutlet weak var txtCDLNumber: UITextField!
    @IBOutlet weak var txtCDLExpirationDate: UITextField!
    
    @IBOutlet weak var imgDriver1: UIImageView!
    @IBOutlet weak var imgDriver2: UIImageView!
    @IBOutlet weak var imgPhotoId: UIImageView!
    @IBOutlet weak var imgOther: UIImageView!
    
    @IBOutlet weak var viewStack1: UIStackView!
    @IBOutlet weak var viewStack2: UIStackView!
    var selectedImageType: ImageType?
    
    var strIsLock = "Yes"
    
    var arrSelectedImages = [[String:UIImage]]()
    
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
            
            //Hide CDL View
            viewCDL.isHidden = true
            viewCDLHeightConstraint.constant = 0
            
            //Hide stack views
            viewStack1.isHidden = true
            viewStack2.isHidden = true
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
                
                //Get the selected images
                let images = info.images as! [[String:UIImage]]
                arrSelectedImages = images
                
                for image in images {
                    if let driver1 = image["driver_1"] {
                        imgDriver1.image = driver1
                    }
                    if let driver2 = image["driver_2"] {
                        imgDriver2.image = driver2
                    }
                    if let photoId = image["photo_id"] {
                        imgPhotoId.image = photoId
                    }
                    if let other = image["other"] {
                        imgOther.image = other
                    }
                }
                
                //CDL Number and expiration date
                txtCDLNumber.text = info.cdlNumber
                txtCDLExpirationDate.text = info.expirationDate
                
            }
            
            //Show CDL View
            viewCDL.isHidden = false
            viewCDLHeightConstraint.constant = 90
            
            //Show stack views
            viewStack1.isHidden = false
            viewStack2.isHidden = false

        }
    }
    @IBAction func selectImageAction(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            selectedImageType = .driver1
        case 2:
            selectedImageType = .driver2
        case 3:
            selectedImageType = .photoId
        case 4:
            selectedImageType = .other
        default:
            break
        }
        
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
        alert.popoverPresentationController?.sourceView = sender
        alert.popoverPresentationController?.sourceRect = sender.frame
        alert.popoverPresentationController?.permittedArrowDirections = [.up]
        
        present(alert, animated: true, completion: nil)

    }
    
    @IBAction func selectExpirationDate(_ sender: UIButton) {
        showHideDatePicker(isShow: true)
    }
    
    @IBAction func cancelDateSelection(_ sender: RoundedBorderButton) {
        showHideDatePicker(isShow: false)
    }
    @IBAction func doneDateSelection(_ sender: RoundedBorderButton) {
        showHideDatePicker(isShow: false)
    }
    
    @IBAction func dateChanged(_ sender: UIDatePicker) {
        txtCDLExpirationDate.text = sender.date.toStringDate()
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
            
            let driverInfo = OutboundShipmentDriverInfo(driverName: driverName, sealNumber: sealNumber, isLockOnTrailer: strIsLock, cdlNumber: txtCDLNumber.text!, expirationDate: txtCDLExpirationDate.text!, driverImages: arrSelectedImages)
            
            outboundDriverInfoDelegate?.didSaveOutboundShipmentDriverInfo(driverInfo: driverInfo)
        }
        
        navigationController?.popViewController(animated: true)

    }
    func validateInput() ->ValidateData {
        
        if ApplicationManager.shared.shipmentType == .INBOUND {
            if (txtDriverName.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)! {
                return .invalid("Please enter driver name.")
            }
            else if (txtSealNumber.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)! {
                return .invalid("Please enter seal number or select No Seal if it is not applicable.")
            }
            
            return.valid

        }
        else {
            if (txtDriverName.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)! {
                return .invalid("Please enter driver name.")
            }
            else if (txtSealNumber.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)! {
                return .invalid("Please enter seal number or select No Seal if it is not applicable.")
            }
            else if (txtCDLNumber.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)! {
                return .invalid("Please enter CDL number..")
            }
            else if (txtCDLExpirationDate.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)! {
                return .invalid("Please enter CDL Expiration date.")
            }
            else if imgDriver1.image == nil {
                return .invalid("Please select Driver Image.")
            }
    
            return.valid

        }
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
    func showHideDatePicker(isShow: Bool) {
        if isShow {
            
            viewDatePickerBottomConstraint.constant = 0
        }
        else {
            viewDatePickerBottomConstraint.constant = -(viewDatePicker.frame.height)
        }
        
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
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
extension DriverSeallnfoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }
        
        guard let selectedImageType = selectedImageType else {
            return
        }
        
        var dictSelectedImage: [String:UIImage]!
        switch selectedImageType {
        case .driver1:
            imgDriver1.image = selectedImage
            dictSelectedImage = ["driver_1":imgDriver1.image!]
        case .driver2:
            imgDriver2.image = selectedImage
            dictSelectedImage = ["driver_2":imgDriver2.image!]
        case .photoId:
            imgPhotoId.image = selectedImage
            dictSelectedImage = ["photo_id":imgPhotoId.image!]
        case .other:
            imgOther.image = selectedImage
            dictSelectedImage = ["other":imgOther.image!]
        }
        
        arrSelectedImages.append(dictSelectedImage)
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
