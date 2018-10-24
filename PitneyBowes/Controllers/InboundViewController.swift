//
//  ViewController.swift
//  ConstantIpadView
//
//  Created by mac on 11/10/18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit

class InboundViewController : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addNavBarImage()
        
    }
    func addNavBarImage() {
        
        let navController = navigationController!
        
        let image = UIImage(named: "pb-new-logo.png") //Your logo url here
        let imageView = UIImageView(image: image)
        
        let bannerWidth = navController.navigationBar.frame.size.width
        let bannerHeight = navController.navigationBar.frame.size.height
        
        let bannerX = bannerWidth / 2 - (image?.size.width)! / 2
        let bannerY = bannerHeight / 2 - (image?.size.height)! / 2
        
        imageView.frame = CGRect(x: bannerX, y: bannerY, width: bannerWidth, height: bannerHeight)
        imageView.contentMode = .scaleAspectFit
        
        navigationItem.titleView = imageView
    }
    
    
    @IBAction func Button_Driver(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DriverSeallnfoViewController")as! DriverSeallnfoViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func button_generalInfoPressed(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "GeneralInfoViewController")as! GeneralInfoViewController
        
        ApplicationManager.shared.shipmentType = "INBOUND"
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


