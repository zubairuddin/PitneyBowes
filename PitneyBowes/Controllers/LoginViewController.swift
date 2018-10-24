//
//  LoginViewController.swift
//  ConstantIpadView
//
//  Created by Dhakad Technosoft Pvt Limited on 21/10/2561 BE.
//  Copyright © 2561 mac. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true

    }

    @IBAction func loginAction(_ sender: RoundedBorderButton) {
        
        //TODO: ADD Validation
        
        APIManager.executeRequest(withQueryString: "email=\(txtEmail.text!)&password=\(txtPassword.text!)")
        
    }
    @IBAction func forgotPasswordAction(_ sender: UIButton) {
    }
    
    //MARK: Custom Methods
    func goToMainView() {
    }
    
}
