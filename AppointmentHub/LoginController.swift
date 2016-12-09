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
import SkyFloatingLabelTextField

class LoginController:UIViewController{
    
    
    @IBOutlet weak var Email: UITextField!
    var cust:Customer?
    
    @IBAction func LogIn(_ sender: UIButton) {
        
        Email.text = "bmc410@comcast.net"
        let text = "Please wait..."
        self.showWaitOverlayWithText((text as NSString) as String)
        
        let obj = RestAPI()
        let url = MYWSCache.sharedInstance["RootURL" as AnyObject] as! String +  "Appointment/LogInByEmail?Email=" + Email.text!
        
        let apptPostData:NSDictionary = NSDictionary()
        
        obj.PostAPI(url, postData: apptPostData) { response in
            self.cust = Mapper<Customer>().map(JSONString: response.rawString()!)
            
            // Remove everything
            self.removeAllOverlays()
            SwiftOverlays.removeAllBlockingOverlays()
            MYWSCache.sharedInstance.setObject(self.cust as AnyObject, forKey: "Appts" as AnyObject)
            self.performSegue(withIdentifier: "AccountInfoSegue", sender: self)
            
        }

    }
    
    func LogIn() {
        
        Email.text = "bmc410@comcast.net"
        let text = "Please wait..."
        self.showWaitOverlayWithText((text as NSString) as String)
        
        let obj = RestAPI()
        let url = MYWSCache.sharedInstance["RootURL" as AnyObject] as! String +  "Appointment/LogInByEmail?Email=" + Email.text!
        
        let apptPostData:NSDictionary = NSDictionary()
        
        obj.PostAPI(url, postData: apptPostData) { response in
            self.cust = Mapper<Customer>().map(JSONString: response.rawString()!)
            
            // Remove everything
            self.removeAllOverlays()
            SwiftOverlays.removeAllBlockingOverlays()
            MYWSCache.sharedInstance.setObject(self.cust as AnyObject, forKey: "Appts" as AnyObject)
            self.performSegue(withIdentifier: "AccountInfoSegue", sender: self)
            
        }
        
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        if self.cust != nil {
           self.performSegue(withIdentifier: "AccountInfoSegue", sender: self)
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextScene = segue.destination as? AccountController
        nextScene?.cust = self.cust

    }
    
       
    func PopController(alert: UIAlertAction!) {
        //backTwo()
    }
    
}
