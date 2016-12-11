//
//  AccountController.swift
//  AppointmentHub
//
//  Created by William McCoy on 12/2/16.
//  Copyright © 2016 William McCoy. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import MZAppearance
import MZFormSheetPresentationController

class AccountController: UIViewController {

    
    var cust: Customer?
    
    @IBOutlet weak var FirstName: SkyFloatingLabelTextField!
    
    @IBOutlet weak var LastName: SkyFloatingLabelTextField!
    
    @IBOutlet weak var EmailAddress: SkyFloatingLabelTextField!
    
    @IBOutlet weak var PhoneNumber: SkyFloatingLabelTextField!
    
    @IBOutlet weak var PINCode: SkyFloatingLabelTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FirstName.text = cust?.FirstName
        LastName.text = cust?.LastName
        EmailAddress.text = cust?.Email
        PhoneNumber.text = cust?.Phone
        PINCode.text = cust?.PIN
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
