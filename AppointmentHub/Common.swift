//
//  Common.swift
//  AppointmentHub
//
//  Created by William McCoy on 11/23/16.
//  Copyright © 2016 William McCoy. All rights reserved.
//

import Foundation

class Common {
    
    
    static func isValidEmail(_ email:String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: email)
    }
    
    static func isValidPhone(_ phone:String) -> Bool{
        let PHONE_REGEX = "^(\\([2-9]|[2-9])(\\d{2}|\\d{2}\\))(-|.|\\s)?\\d{3}(-|.|\\s)?\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        
        if phoneTest.evaluate(with: phone) {
            return (true)
        }
        return (false)
    }
    
    static func IsValidGuid(_ guid: String) -> Bool{
        let guidPred = NSPredicate(format: "SELF MATCHES %@", "((\\{|\\()?[0-9a-f]{8}-?([0-9a-f]{4}-?){3}[0-9a-f]{12}(\\}|\\))?)|(\\{(0x[0-9a-f]+,){3}\\{(0x[0-9a-f]+,){7}0x[0-9a-f]+\\}\\})")
        
        if guidPred.evaluate(with: guid) {
            return true
        } else {
            return false
        }
    }
    
    
    static func ShowAlert(_ obj: UIViewController, Message:String, Actions: [UIAlertAction],Title:String){
        let alertController = UIAlertController(title: "", message:
            Message, preferredStyle: UIAlertControllerStyle.alert)
        
        for action: UIAlertAction in Actions{
            alertController.addAction(action)
        }
        
        obj.present(alertController, animated: true)
        
        
    }
}
