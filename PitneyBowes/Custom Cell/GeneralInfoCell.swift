//
//  GeneralInfoCell.swift
//  PitneyBowes
//
//  Created by Zubair on 24/10/18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit

class GeneralInfoCell: UITableViewCell {
    
    @IBOutlet weak var lblBol: UILabel!
    @IBOutlet weak var lblProNumber: UILabel!
    @IBOutlet weak var lblCarrier: UILabel!
    @IBOutlet weak var lblNgsLocation: UILabel!
    @IBOutlet weak var lblOriginOrDestination: UILabel!
    
    var isInbound = false
    
    var shipment: Shipment? {
        didSet {
            lblBol.text = shipment?.Shipment?.bol
            lblProNumber.text = shipment?.Shipment?.pro_number
            lblCarrier.text = shipment?.Shipment?.carrier
            lblNgsLocation.text = shipment?.Shipment?.ngs_location
            lblOriginOrDestination.text = shipment?.Shipment?.origin
        }
    }
}
