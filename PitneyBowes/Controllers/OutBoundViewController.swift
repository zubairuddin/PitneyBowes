//
//  OutBoundViewController.swift
//  ConstantIpadView
//
//  Created by mac on 15/10/18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit

class OutBoundViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "New DaL!"
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        let CancleButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel,
                                           target: self,
                                           action: #selector(Cancle(_:)))
        self.navigationItem.leftBarButtonItem = CancleButton
        
    }

    @objc func Cancle(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    
    }
    @IBAction func generalInfo_pressed(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "GeneralInfoViewController")as! GeneralInfoViewController
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    @IBAction func driver_pressed(){
        
    }

    @IBAction func securityQue_pressed(){
        
    }

    @IBAction func tractorAndTrailor_pressed(){
        
    }

    
   
}
