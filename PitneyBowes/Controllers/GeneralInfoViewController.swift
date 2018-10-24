//
//  FirstViewController.swift
//  ConstantIpadView
//
//  Created by mac on 11/10/18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit

class GeneralInfoViewController: UIViewController{
   
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "General Info Entries"
        
            self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add(_:))),  animated: true)
        
        
    }
   
     @objc func add(_ sender: Any){
        let next = self.storyboard?.instantiateViewController(withIdentifier: "AddGeneralInfoViewController")as! AddGeneralInfoViewController
        self.navigationController?.pushViewController(next, animated:true)
    }
    
}
    
  


