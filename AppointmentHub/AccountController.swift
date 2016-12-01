//
//  AccountController.swift
//  AppointmentHub
//
//  Created by William McCoy on 11/27/16.
//  Copyright © 2016 William McCoy. All rights reserved.
//
import UIKit
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class AccountController:UIViewController{
    
    @IBAction func SaveUser(_ sender: UIButton) {
        var actions: [UIAlertAction] = [UIAlertAction]()
        actions.append(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: self.PopController))
        
        Common.ShowAlert(self, Message: "Submitted successfully.", Actions: actions, Title: "")

    }
    
    func PopController(alert: UIAlertAction!) {
        //backTwo()
    }
    
}
