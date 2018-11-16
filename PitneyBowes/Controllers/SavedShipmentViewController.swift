//
//  SavedShipmentViewController.swift
//  PitneyBowes
//
//  Created by Zubair on 07/11/18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit

class SavedShipmentViewController: UIViewController {

    var arrSavedInbound = [SavedInbound]()
    var arrSavedOutbound = [SavedOutbound]()
    
    let type = ApplicationManager.shared.shipmentType
    
    @IBOutlet weak var colSavedShipment: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if type == .INBOUND {
            title = "Saved Inbound"
        }
        else {
            title = "Saved Outbound"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if type == .INBOUND {
            arrSavedInbound = DatabaseManager.fetchAllSavedInbound()
        }
        else {
            arrSavedOutbound = DatabaseManager.fetchAllSavedOutbound()
        }
        
        colSavedShipment.reloadData()
        //tblSavedShipments.reloadData()
    }
    
}

extension SavedShipmentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if type == .INBOUND {
            print("Number of rows in saved shipment screen is: \(arrSavedInbound.count)")
            return arrSavedInbound.count
        }
        else {
            return arrSavedOutbound.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedShipmentCell", for: indexPath) as! SavedShipmentCell
        
        if type == .INBOUND {
            let shipment = arrSavedInbound[indexPath.row]
            cell.lblShipmentName.text = shipment.generalInfo?.bolNumber

        }
        else {
            let shipment = arrSavedOutbound[indexPath.row]
            cell.lblShipmentName.text = shipment.generalInfo?.bolNumber

        }
        
        return cell
    }
}

extension SavedShipmentViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if type == .INBOUND {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "InboundViewController")as! InboundViewController
            vc.savedInbound = arrSavedInbound[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)

        }
        else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "OutBoundViewController")as! OutBoundViewController
            vc.savedOutbound = arrSavedOutbound[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension SavedShipmentViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if type == .INBOUND {
            print("Number of rows in saved shipment screen is: \(arrSavedInbound.count)")
            return arrSavedInbound.count
        }
        else {
            return arrSavedOutbound.count
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SavedShipmentCollectionViewCell", for: indexPath) as! SavedShipmentCollectionViewCell
        
        if type == .INBOUND {
            let shipment = arrSavedInbound[indexPath.row]
            cell.lblShipmentIdentifier.text = shipment.generalInfo?.bolNumber
            
        }
        else {
            let shipment = arrSavedOutbound[indexPath.row]
            cell.lblShipmentIdentifier.text = shipment.generalInfo?.bolNumber
            
        }
        
        return cell
    }
}
extension SavedShipmentViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if type == .INBOUND {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "InboundViewController")as! InboundViewController
            vc.savedInbound = arrSavedInbound[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "OutBoundViewController")as! OutBoundViewController
            vc.savedOutbound = arrSavedOutbound[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
