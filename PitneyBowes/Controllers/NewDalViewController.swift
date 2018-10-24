//
//  SevenViewController.swift
//  ConstantIpadView
//
//  Created by mac on 15/10/18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit

class NewDalViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
     // self.title = "New DaL!"
           // self.title = "New DaL"
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        let CancleButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel,
                                           target: self,
                                           action: #selector(Cancle(_:)))
        self.navigationItem.leftBarButtonItem = CancleButton
        
    }
    @objc func Cancle(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }


    @IBAction func Button_Security(_ sender: UIButton) {
        let time = self.storyboard?.instantiateViewController(withIdentifier: "SecurityQuesionViewController")as! SecurityQuesionViewController
        self.navigationController?.pushViewController(time, animated: true)
    }
    @IBAction func button_Tractor(_ sender: UIButton) {
        let time = self.storyboard?.instantiateViewController(withIdentifier: "TractorandTrailerViewController")as! TractorandTrailerViewController
        self.navigationController?.pushViewController(time, animated: true)
    }
    
    @IBAction func button_Driver(_ sender: UIButton) {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "SecurityQuesionViewController")as! SecurityQuesionViewController
        self.navigationController?.pushViewController(next, animated: true)
     
    }
    
    @IBAction func button_gene(_ sender: UIButton) {
       let text = self.storyboard?.instantiateViewController(withIdentifier: "InboundViewController")as! InboundViewController
        self.navigationController?.pushViewController(text, animated: true)
    }
 
   }



