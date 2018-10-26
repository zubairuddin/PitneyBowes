//
//  FirstViewController.swift
//  ConstantIpadView
//
//  Created by mac on 11/10/18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit
import SVProgressHUD
class GeneralInfoViewController: UIViewController{
    
    @IBOutlet weak var txtCargo: UITextField!
    @IBOutlet weak var tblShipments: UITableView!
    @IBOutlet weak var viewPicker: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var viewPickerBottomConstraint: NSLayoutConstraint!
    
    var arrShipments = [Shipment]()
    var arrEmployees = [Employee]()
    var selectedEmployee: Employee?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "General Info Entries"
        
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add(_:)))
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        tblShipments.register(UINib(nibName: "GeneralInfoCell", bundle: Bundle.main), forCellReuseIdentifier: "GeneralInfoCell")
        
        //
        fetchEmployees()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchGeneralInfoEntries()
    }
   
    @IBAction func selectEmployee(_ sender: UIButton) {
        showHideLocationPicker(isShow: true)
    }
    @IBAction func cancelEmployeeSelection(_ sender: RoundedBorderButton) {
        showHideLocationPicker(isShow: false)
    }
    @IBAction func doneEmployeeSelection(_ sender: RoundedBorderButton) {
        showHideLocationPicker(isShow: false)
    }
    @objc func add(_ sender: Any){
        let next = self.storyboard?.instantiateViewController(withIdentifier: "AddGeneralInfoViewController") as! AddGeneralInfoViewController
        self.navigationController?.pushViewController(next, animated:true)
    }
    
    func showHideLocationPicker(isShow: Bool) {
        if isShow {
            viewPickerBottomConstraint.constant = 0
        }
        else {
            viewPickerBottomConstraint.constant = -(viewPicker.frame.height)
        }
        
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }

    func fetchGeneralInfoEntries() {
        guard let userId = ApplicationManager.shared.loggedInUserId, let type = ApplicationManager.shared.shipmentType else {
            return
        }
        
        SVProgressHUD.show(withStatus: "Loading...")
        SVProgressHUD.setDefaultMaskType(.black)
        
        let queryString = "user_id=\(userId)&type=\(type)"
        APIManager.executeRequest(appendingPath: "shipments/index", withQueryString: queryString, httpMethod: "POST") { (data, error) in
            if error != nil {
                print("Error while fetching shipments: \(error!.localizedDescription)")
                self.hideHud()
                return
            }
            
            guard let responseData = data else {
                self.hideHud()
                return
            }
            
            let json = try! JSONSerialization.jsonObject(with: responseData, options: .allowFragments)
            print(json)
            
            //Decode the info and reload table view
            
            do {
                let shipments = try JSONDecoder().decode(ShipmentData.self, from: responseData)
                guard let shipmentsArray = shipments.shipments  else {
                    self.hideHud()
                    return
                }
                
                self.arrShipments = shipmentsArray

                DispatchQueue.main.async {
                    self.hideHud()
                    self.tblShipments.reloadData()
                }
                
            }
            catch let error {
                print("Unable to decode: \(error.localizedDescription)")
            }
            
        }
    }
    
    func fetchEmployees() {
        //http://smartpro-technologies.com/api/employees
        APIManager.executeRequest(appendingPath: "employees", withQueryString: "", httpMethod: "GET") { (data, error) in
            if error != nil {
                print("Error while fetching employees: \(error!.localizedDescription)")
                return
            }
            
            guard let responseData = data else {
                return
            }
            
            do {
                let employees = try JSONDecoder().decode(Employees.self, from: responseData)
                print(employees)
                guard let arrData = employees.data else {
                    return
                }
                
                self.arrEmployees = arrData
                
                DispatchQueue.main.async {
                    self.pickerView.reloadAllComponents()
                }
                
            }
            catch let error {
                print(error.localizedDescription)
            }
        }
    }
}

extension GeneralInfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrShipments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GeneralInfoCell", for: indexPath) as! GeneralInfoCell
        
        let shipment = arrShipments[indexPath.row]
        cell.shipment = shipment
        return cell
    }
}

extension GeneralInfoViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrEmployees[row].Employee?.name
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedEmployee = arrEmployees[row]
        txtCargo.text = selectedEmployee?.Employee?.name
    }
}

extension GeneralInfoViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrEmployees.count
    }
}

  


