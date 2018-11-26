//
//  InboundShipmentCell.swift
//  PitneyBowes
//
//  Created by Zubair on 24/11/18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit

class InboundGeneralInfoCell: UITableViewCell {
    
    override func awakeFromNib() {
        txtBol.delegate = self
        txtPro.delegate = self
        txtOrigin.delegate = self
    }
    
    @IBOutlet weak var txtBol: UITextField!
    @IBOutlet weak var txtPro: UITextField!
    @IBOutlet weak var txtOrigin: UITextField!
    
    @IBOutlet weak var btnBolNotApplicable: UIButton!
    @IBOutlet weak var btnProNotApplicable: UIButton!
    
    @IBOutlet weak var btnScanBol: RoundedBorderButton!
    @IBOutlet weak var btnScanPro: RoundedBorderButton!
    @IBOutlet weak var btnScanBolHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnScanBolTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnScanBolBottom: NSLayoutConstraint!
    
    @IBOutlet weak var btnScanProHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnScanProTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnScanProBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewScanner: UIView!
    @IBOutlet weak var viewScannerHeightConstraint: NSLayoutConstraint!
}


extension InboundGeneralInfoCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtBol {
            txtPro.becomeFirstResponder()
        }
        else if textField == txtPro {
            txtOrigin.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtBol {
            btnScanBol.isHidden = false
            btnScanBolHeightConstraint.constant = 30
            
            btnScanPro.isHidden = true
            btnScanProHeightConstraint.constant = 0
            
            UIView.animate(withDuration: 0.3) {
                self.contentView.layoutIfNeeded()
            }
            
        }
        if textField == txtPro {
            btnScanPro.isHidden = false
            btnScanProHeightConstraint.constant = 30
            
            btnScanBol.isHidden = true
            btnScanBolHeightConstraint.constant = 0
            
            UIView.animate(withDuration: 0.5) {
                self.contentView.layoutIfNeeded()
            }
        }
            
        else if textField == txtOrigin{
            btnScanPro.isHidden = true
            btnScanPro.isHidden = true
            btnScanProHeightConstraint.constant = 0
            btnScanBolHeightConstraint.constant = 0
            
            UIView.animate(withDuration: 0.5) {
                self.contentView.layoutIfNeeded()
            }
        }
    }
}
