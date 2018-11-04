//
//  SecondViewController.swift
//  ConstantIpadView
//
//  Created by mac on 12/10/18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit
import CoreLocation
import AVFoundation

protocol SaveInboundGeneralInfoProtocol {
    func didSaveInboundShipmentGeneralInfo(generalInfo: InboundShipmentGeneralInfo)
}
protocol SaveOutboundGeneralInfoProtocol {
    func didSaveOutboundShipmentGeneralInfo(generalInfo: OutboundShipmentGeneralInfo)
}

struct InboundShipmentGeneralInfo {
    var bol: String
    var proNumber: String
    var carrier: String
    var ngsLocation: String
    var latitude: Double
    var longitude: Double
    var origin: String
    var state: String
    var employeeName: String
}

struct OutboundShipmentGeneralInfo {
    var bol: String
    var proNumber: String
    var carrier: String
    var ngsLocation: String
    var latitude: Double
    var longitude: Double
    var destination: String
    var sealNumber: String
    var state: String
    var employeeName: String
}

class AddGeneralInfoViewController: UIViewController {
    
    @IBOutlet weak var viewScanner: UIView!
    @IBOutlet weak var btnScan: RoundedBorderButton!
    @IBOutlet weak var txtBol: UITextField!
    @IBOutlet weak var txtPro: UITextField!
    @IBOutlet weak var txtCarrier: UITextField!
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var txtOriginOrDestination: UITextField!
    @IBOutlet weak var txtSealNumber: UITextField!

    @IBOutlet weak var lblSealNumber: UILabel!
    @IBOutlet weak var lblOriginOrDestination: UILabel!

    @IBOutlet weak var viewPickerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewSealInfoHeight: NSLayoutConstraint!
    
    @IBOutlet weak var viewPicker: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var btnNASealNumber: UIButton!
    
    var inboundGeneralInfoDelegate: SaveInboundGeneralInfoProtocol?
    var outboundGeneralInfoDelegate: SaveOutboundGeneralInfoProtocol?
    
    var strSelectedEmployeeName = ""
    
    var latitude = 0.0
    var longitude = 0.0
    
    var arrLocations = [Location]()
    var selectedLocation: Location?
    
    var session: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var redLineView: UIView?

    //
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
        
        if type == .INBOUND {
            print("inbound shipment")
            lblSealNumber.isHidden = true
            txtSealNumber.isHidden = true
            btnNASealNumber.isHidden = true
            lblOriginOrDestination.text = "Origin"
            viewSealInfoHeight.constant = 0
            btnNASealNumber.isHidden = true
        }
        else if type == .OUTBOUND{
            print("outbound shipment")
            lblSealNumber.isHidden = false
            txtSealNumber.isHidden = false
            btnNASealNumber.isHidden = false
            lblOriginOrDestination.text = "Destination"
            viewSealInfoHeight.constant = 30
            btnNASealNumber.isHidden = false
        }
        
        //load the scan button initially.
        btnScan.isHidden = true
        callGetLocationsAPI()
        
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        AppUtility.lockOrientation(.all)
    }
    @IBAction func scanTapped(_ sender: RoundedBorderButton) {
        //view.endEditing(true)
        startScan()
    }
    
    @IBAction func cancelSelection(_ sender: RoundedBorderButton) {
        showHideLocationPicker(isShow: false)
    }
    
    @IBAction func doneSelection(_ sender: RoundedBorderButton) {
        showHideLocationPicker(isShow: false)
        txtOriginOrDestination.text = selectedLocation?.name
    }
    
    @IBAction func bolNotApplicableAction(_ sender: UIButton) {
        txtBol.text = "N/A"
    }
    @IBAction func proNotApplicableAction(_ sender: UIButton) {
        txtPro.text = "N/A"
    }
    
    @IBAction func sealNotApplicableAction(_ sender: UIButton) {
        txtSealNumber.text = "N/A"
    }
    @objc func cancel(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func selectOriginOrDestinationTapped(_ sender: UIButton) {
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

            getLocationFromAddressAndSaveGeneralInfo(address: txtLocation.text!)
            
            //TODO: Navigate to the inbound/outbound view controller
        case .invalid(let message):
            presentAlert(withTitle: message, message: "")
        }
    }
    
    func getLocationFromAddressAndSaveGeneralInfo(address: String) {
        let geoCoder = CLGeocoder()
        
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard let placemarks = placemarks, let location = placemarks.first?.location else {
                // handle no location found
                self.presentAlert(withTitle: "Location Not found.", message: "Can not find the latitude and longitude for the ngs location you have entered. Please enter correct location")
                    return
            }
            
            self.latitude = Double(location.coordinate.latitude)
            self.longitude = Double(location.coordinate.longitude)
            
            guard let type = ApplicationManager.shared.shipmentType else {
                return
            }
            
            if type == .INBOUND {
                self.saveGeneralInfoForInboundShipment()
            }
            else {
                self.saveGeneralInfoForOutboundShipment()
            }
            
        }
        
    }
    
    func saveGeneralInfoForInboundShipment() {
        
        let bolNumber = txtBol.text!
        let proNumber = txtPro.text!
        let carrier = txtCarrier.text!
        let ngsLocation = txtLocation.text!
        
        let origin = txtOriginOrDestination.text!
        
        let generalInfo = InboundShipmentGeneralInfo(bol: bolNumber, proNumber: proNumber, carrier: carrier, ngsLocation: ngsLocation, latitude: latitude, longitude: longitude, origin: origin, state: selectedLocation?.state_code ?? "", employeeName: strSelectedEmployeeName)
        
        //Pass the general info to the InboundViewController via it's delegate
        inboundGeneralInfoDelegate?.didSaveInboundShipmentGeneralInfo(generalInfo: generalInfo)
        popToInboundVC()
    }
    
    func saveGeneralInfoForOutboundShipment() {
        
        let bolNumber = txtBol.text!
        let proNumber = txtPro.text!
        let carrier = txtCarrier.text!
        let ngsLocation = txtLocation.text!
        let destination = txtOriginOrDestination.text!
        let sealNumber = txtSealNumber.text!
        
        let generalInfo = OutboundShipmentGeneralInfo(bol: bolNumber, proNumber: proNumber, carrier: carrier, ngsLocation: ngsLocation, latitude: latitude, longitude: longitude, destination: destination, sealNumber: sealNumber, state: selectedLocation?.state_code ?? "", employeeName: strSelectedEmployeeName)
        
        //Pass the general info to the OutboundViewController via it's delegate
        outboundGeneralInfoDelegate?.didSaveOutboundShipmentGeneralInfo(generalInfo: generalInfo)
        popToOutboundVC()
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

    func showHideLocationPicker(isShow: Bool) {
        if isShow {
            
            txtLocation.resignFirstResponder()
            viewPickerBottomConstraint.constant = 0
            
            //Default row selection
            let row = pickerView.selectedRow(inComponent: 0)
            pickerView(pickerView, didSelectRow: row, inComponent:0)
            
            //Hide the keyboard is it's shown
            if txtCarrier.isFirstResponder {
                txtCarrier.resignFirstResponder()
            }

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
    
    func callGetLocationsAPI() {
        
        let type = ApplicationManager.shared.shipmentType == .INBOUND ? "origin" : "destination"
        
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
                
                let json = try! JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as! [String:Any]
                print(json)
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

//Scanning code
extension AddGeneralInfoViewController {
    func startScan() {
        
        //Barcode TESTING: https://barcode.tec-it.com/en/Code39?data=ABC-1234
        
        //Create a capture session
        session = AVCaptureSession()
        
        //Get the device from which input will be taken
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            return
        }
        
        
        // Get an instance of the AVCaptureDeviceInput class using the previous device object.
        let deviceInput: AVCaptureDeviceInput?
        
        do {
            deviceInput = try AVCaptureDeviceInput(device: captureDevice)
            
            let output = AVCaptureMetadataOutput()
            
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            session?.addInput(deviceInput!)
            session?.addOutput(output)
            
//            output.metadataObjectTypes = [.ean13, .upce, .aztec, .code128, .code39, .code39Mod43, .dataMatrix, .ean8, .qr, .pdf417, .itf14, .face, .interleaved2of5, .code93,]
            
            output.metadataObjectTypes = output.availableMetadataObjectTypes
            
            print(output.availableMetadataObjectTypes)
            //Add the preview layer
            guard let captureSession = session else {
                return
            }
            
            //Video recording layer
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = .resizeAspectFill
            
            //videoPreviewLayer?.frame = view.layer.bounds
            videoPreviewLayer?.frame = viewScanner.layer.bounds
            
            videoPreviewLayer?.isHidden = false
            viewScanner.layer.addSublayer(videoPreviewLayer!)
            
            //Red line view
            redLineView = UIView()
            redLineView?.isHidden = false
            redLineView?.layer.borderColor = UIColor.red.cgColor
            redLineView?.layer.borderWidth = 10
            redLineView?.frame = CGRect(x: videoPreviewLayer!.frame.origin.x + 20, y: videoPreviewLayer!.frame.size.height / 2 + videoPreviewLayer!.frame.origin.y, width: videoPreviewLayer!.frame.width - 40, height: 10)
            viewScanner.addSubview(redLineView!)
            
            //view.bringSubviewToFront(redLineView!)
            
            //Start video
            session?.startRunning()
            
            //Restrict scanning to a certain rect
            let visibleRect = videoPreviewLayer?.metadataOutputRectConverted(fromLayerRect: redLineView!.frame)
            
            //if this line is written before starting the session, it won't work
            output.rectOfInterest = visibleRect!
        }
            
        catch {
            presentAlert(withTitle: "Scanning not supported.", message: "")
            
        }
    }
    
    func stopScan() {
        session?.stopRunning()
        session = nil
        videoPreviewLayer?.isHidden = true
        redLineView?.isHidden = true
    }
}

extension AddGeneralInfoViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if metadataObjects.count > 0 {
            guard let readableCode = metadataObjects.first as? AVMetadataMachineReadableCodeObject else {
                return
            }
            
            //No need to check for .ean13 barcodes as we will detect all types of barcodes
            //if readableCode.type == .ean13 {
                guard let stringCode = readableCode.stringValue else {
                    return
                }
                
                //Stop scanning
                stopScan()
                
                print("Barcode detected: \(stringCode)")
                
                //Show the scanned code in the selected text field
                if txtBol.isFirstResponder {
                    txtBol.text = stringCode.uppercased()
                }
                else if txtPro.isFirstResponder {
                    txtPro.text = stringCode.uppercased()
                }
                
                return
            //}
        }
    }
}
extension AddGeneralInfoViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrLocations[row].name
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if arrLocations.count > 0 {
           selectedLocation = arrLocations[row]
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

extension AddGeneralInfoViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtBol {
            txtPro.becomeFirstResponder()
        }
        else if textField == txtPro {
            txtCarrier.becomeFirstResponder()
        }
        else if textField == txtCarrier {
            txtLocation.becomeFirstResponder()
        }

        else {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtBol || textField == txtPro {
            btnScan.isHidden = false
        }
        else {
            btnScan.isHidden = true
        }
    }
}
