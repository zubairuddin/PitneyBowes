//
//  LoginViewController.swift
//  ConstantIpadView
//
//  Created by Dhakad Technosoft Pvt Limited on 21/10/2561 BE.
//  Copyright © 2561 mac. All rights reserved.
//

import UIKit
import SVProgressHUD

enum ValidateData {
    case invalid(String)
    case valid
}

class LoginViewController: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //self.navigationController?.navigationBar.isHidden = true

    }

    @IBAction func loginAction(_ sender: RoundedBorderButton) {
        
        //TODO: ADD Validation and Loading
        let isInputValid = validateInput()
        
        switch isInputValid {
        case .valid:
            callLoginAPI()
        case .invalid(let message):
            presentAlert(withTitle: message, message: "")
            
        }
        
        
    }
    @IBAction func forgotPasswordAction(_ sender: UIButton) {
    }
    
    //MARK: Custom Methods
    
    //Input validation
    func validateInput() ->ValidateData {
        if (txtEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)! {
            return .invalid("Please enter email address.")
        }
        else if (txtPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)! {
            return .invalid("Please enter password.")
        }
        
        return.valid
    }
    
    //Login API Call
    func callLoginAPI() {
        
        //Show HUD
        SVProgressHUD.show(withStatus: "Logging in...")
        SVProgressHUD.setDefaultMaskType(.black)
        
        APIManager.executeRequest(appendingPath: "users/signin", withQueryString: "email=\(txtEmail.text!)&password=\(txtPassword.text!)", httpMethod: "POST") { (data, error) in
            
            //Hide Hud
            
            if error != nil {
                self.hideHud()
                print("Error: \(error!.localizedDescription)")
                return
            }
            
            guard let responseData = data else {
                self.hideHud()
                return
            }
            
            //let json = try! JSONSerialization.jsonObject(with: responseData, options: .allowFragments)
            //print(json)
            
            do {
                let users = try JSONDecoder().decode(UserData.self, from: responseData)
                guard let userData = users.data, let loggedInUser = userData[0].User else {
                    return
                }
                
                //Fetch the user detail from loggedInUser object
                print(loggedInUser)
                
                guard let loggedInUserId = loggedInUser.id else {
                    print("User ID not available")
                    return
                }
                
                //Save logged-in user id in singleton
                ApplicationManager.shared.loggedInUserId = loggedInUserId
                
                self.hideHud()
                
                DispatchQueue.main.async {
                   // DatabaseManager.saveLoggedInUserInCoreData(userDetail: loggedInUser)
                    self.goToMainView()
                }
                
            }
            catch let error {
                print("Unable to decode: \(error.localizedDescription)")
            }
        }
    }
    
    //Navigate to main screen
    func goToMainView() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
