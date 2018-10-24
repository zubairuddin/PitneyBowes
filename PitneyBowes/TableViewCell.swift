//
//  TableViewCell.swift
//  ConstantIpadView
//
//  Created by mac on 16/10/18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet var lbl_Bol: UILabel!
    @IBOutlet var lbl_SEcond: UILabel!
    
    @IBOutlet var lbl_Five: UILabel!
    @IBOutlet var lbl_Four: UILabel!
    @IBOutlet var lbl_Third: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
