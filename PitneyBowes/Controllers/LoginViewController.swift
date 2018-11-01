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
        let alert = UIAlertController(title: "Please enter your email address.", message: "", preferredStyle: .alert)
        alert.addTextField { (emailField) in
            emailField.placeholder = "Email"
        }
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            let emailField = alert.textFields?[0]
            guard let email = emailField?.text else {
                return
            }
            
            if !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&  self.isValidEmail(strEmail: email) {
                print("Call Forgot password API")
                self.callForgotPasswordAPI(withEmail: email)
            }
            
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: Custom Methods
    
    //Input validation
    func isValidEmail(strEmail:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: strEmail)
    }
    
    func validateInput() ->ValidateData {
        if (txtEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)! {
            return .invalid("Please enter email address.")
        }
        else if !isValidEmail(strEmail: txtEmail.text!) {
            return .invalid("Please enter correct email address.")
        }
        else if (txtPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)! {
            return .invalid("Please enter password.")
        }
        
        return.valid
    }
    
    //Forgot password API
    func callForgotPasswordAPI(withEmail email: String) {
        
        SVProgressHUD.show(withStatus: "Please wait...")
        SVProgressHUD.setDefaultMaskType(.black)
        
        APIManager.executeRequest(appendingPath: "users/forgot", withQueryString: "email=\(email)", httpMethod: "POST") { (data, error) in
            
            if error != nil {
                self.hideHud()
                print("Error: \(error!.localizedDescription)")
                return
            }
            
            guard let responseData = data else {
                self.hideHud()
                return
            }
            
            do {
                
                self.hideHud()
                
                guard let json = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as? [String:Any] else {
                    return
                }
                
                print(json)
                
                guard let message = json["message"] as? String else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.presentAlert(withTitle: message, message: "")
                }

            }
            catch let error {
                self.hideHud()
                DispatchQueue.main.async {
                    self.presentAlert(withTitle: error.localizedDescription, message: "")
                }
                
            }
        }
        
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
            
            
            do {
                let users = try JSONDecoder().decode(UserData.self, from: responseData)
                guard let userData = users.data, let loggedInUser = userData[0].User else {
                    self.hideHud()
                    DispatchQueue.main.async {
                        self.presentAlert(withTitle: "Unable to login.", message: "Please make sure you have entered correct email and password and try again.")
                    }
                    return
                }
                
                //Fetch the user detail from loggedInUser object
                print(loggedInUser)
                
                guard let loggedInUserId = loggedInUser.id else {
                    print("User ID not available")
                    self.hideHud()
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

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtEmail {
            txtPassword.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
        }
        
        return true
    }
}
