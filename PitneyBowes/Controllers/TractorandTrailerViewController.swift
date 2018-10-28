//
//  TenViewController.swift
//  ConstantIpadView
//
//  Created by mac on 15/10/18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit

struct OutboundShipmentTractorInfo {
    let trailerNumber: String
    let tractorDotNumber: String
    let tractorPlate: String
    let lockOnTrailer: String
    let tractorAndTrailerImages : [[String:UIImage]]
}

protocol SaveOutboundTractorAndTrailerInfoProtocol {
    func didSaveTractorAndTrailerInfo(tractorAndTrailerInfo: OutboundShipmentTractorInfo)
}

class TractorandTrailerViewController: UIViewController {

    enum ImageType {
        case tractor
        case tractorDot, other1, tractorPlate, trailer, other2
    }
    
    @IBOutlet weak var segmentLockOnTrailer: UISegmentedControl!
    @IBOutlet weak var txtTrailerNumber: UITextField!
    @IBOutlet weak var txtDotNumber: UITextField!
    @IBOutlet weak var txtTractorPlate: UITextField!
    @IBOutlet weak var imgTractor: UIImageView!
    @IBOutlet weak var imgTractorDot: UIImageView!
    @IBOutlet weak var imgOther1: UIImageView!
    @IBOutlet weak var imgTractorPlate: UIImageView!
    @IBOutlet weak var imgTrailer: UIImageView!
    @IBOutlet weak var imgOther2: UIImageView!
    
    var selectedType: ImageType?
    var strLock = "Yes"
    var outboundTractorInfoDelegate: SaveOutboundTractorAndTrailerInfoProtocol?
    
    var arrSelectedImages = [[String:UIImage]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Tractor and Trailer Details"
        
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveTractorAndTrailerInfo))
        navigationItem.rightBarButtonItem = saveButton
        
        segmentLockOnTrailer.selectedSegmentIndex = 0
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            strLock = "Yes"
        case 1:
            strLock = "No"
        case 2:
            strLock = "N/A"
            
        default:
            break
        }

    }
    
    @IBAction func selectImageAction(_ sender: UIButton) {
        
        //1.tractor
        //2.tractor dot
        //3.other 1
        //4.tractor plate
        //5.trailer
        //6.other 2
        
        switch sender.tag {
        case 1:
            selectedType = .tractor
        case 2:
            selectedType = .tractorDot
        case 3:
            selectedType = .other1
        case 4:
            selectedType = .tractorPlate
        case 5:
            selectedType = .trailer
        case 6:
            selectedType = .other2
            
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
    
    @objc func saveTractorAndTrailerInfo() {
        
        let isInputValid = validateInput()
        
        switch isInputValid {
        case .valid:
            saveInfo()
        case .invalid(let message):
            presentAlert(withTitle: message, message: "")
        }
    }
    
    func validateInput() ->ValidateData {
        if (txtTractorPlate.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)! {
            return .invalid("Tractor plate can't be empty.")
        }
        else if (txtDotNumber.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)! {
            return .invalid("Tractor DOT number can't be empty.")
        }
        else if (txtTrailerNumber.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)! {
            return .invalid("Trailer number can't be empty.")
        }

        return.valid
    }

    func saveInfo() {
        let trailerNumber = txtTrailerNumber.text!
        let dotNumber = txtDotNumber.text!
        let plate = txtTractorPlate.text!
        
        let info = OutboundShipmentTractorInfo(trailerNumber: trailerNumber, tractorDotNumber: dotNumber, tractorPlate: plate, lockOnTrailer: strLock, tractorAndTrailerImages: arrSelectedImages)
        
        outboundTractorInfoDelegate?.didSaveTractorAndTrailerInfo(tractorAndTrailerInfo: info)
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

extension TractorandTrailerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }
        
        guard let selectedImageType = selectedType else {
            return
        }
        
        var dictSelectedImage: [String:UIImage]!
        switch selectedImageType {
        case .tractor:
            imgTractor.image = selectedImage
            dictSelectedImage = ["tractor_pic":imgTractor.image!]
        case .tractorDot:
            imgTractorDot.image = selectedImage
            dictSelectedImage = ["tractor_dot_pic":imgTractorDot.image!]
        case .other1:
            imgOther1.image = selectedImage
            dictSelectedImage = ["other_pic_1":imgOther1.image!]
        case .tractorPlate:
            imgTractorPlate.image = selectedImage
            dictSelectedImage = ["tractor_plate_pic":imgTractorPlate.image!]
        case .trailer:
            imgTrailer.image = selectedImage
            dictSelectedImage = ["trailer_pic":imgTrailer.image!]
        case .other2:
            imgOther2.image = selectedImage
            dictSelectedImage = ["other_pic_2":imgOther2.image!]
        }
        
        arrSelectedImages.append(dictSelectedImage)
        dismiss(animated: true, completion: nil)

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension TractorandTrailerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtTractorPlate {
            txtDotNumber.becomeFirstResponder()
        }
        else if textField == txtDotNumber {
            txtTrailerNumber.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
        }
        return true
    }
}
