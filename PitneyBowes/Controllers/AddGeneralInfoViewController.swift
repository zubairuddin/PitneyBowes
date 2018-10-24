//
//  SecondViewController.swift
//  ConstantIpadView
//
//  Created by mac on 12/10/18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit

class AddGeneralInfoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "General Information"
       self.navigationItem.setHidesBackButton(true, animated: false)
        
        let CancleButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel,
                                          target: self,
                                          action: #selector(Cancle(_:)))
        self.navigationItem.leftBarButtonItem = CancleButton
       
       
  
        
     let SaveButton = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.plain, target: self, action: "Save")
        self.navigationItem.rightBarButtonItem = SaveButton
    }
       
       @objc func Cancle(_ sender: Any){
       self.navigationController?.popViewController(animated: true)
  }     
   
}



