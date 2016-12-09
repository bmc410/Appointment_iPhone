//
//  PopupViewController.swift
//  PresentrExample
//
//  Created by Daniel Lozano on 8/29/16.
//  Copyright © 2016 danielozano. All rights reserved.
//

import UIKit
import Presentr
import Eureka
import ObjectMapper
import Alamofire
import AlamofireObjectMapper
import SkyFloatingLabelTextField

class LoginViewController: FormViewController {

    var cust:Customer?
    override func viewDidLoad() {
        super.viewDidLoad()

        form +++
            Helper.CreateSection(MyView: self, title: "LOGIN")
                      
            <<< TextRow() {
                $0.title = "Login:"
                $0.placeholder = "Login or email"
                $0.tag = "uname"
                }
            
            <<< PasswordRow() {
                $0.title = "Password:"
                $0.placeholder = "Password"
                $0.tag = "pword"
                }
        
            +++ Section()
            
            <<< ButtonRow() { (row: ButtonRow) -> Void in
                row.title = "Login"
                }
                .onCellSelection { [weak self] (cell, row) in
                    self?.DoLogin()
            }
        
            +++ Section()
            
            <<< ButtonRow() { (row: ButtonRow) -> Void in
                row.title = "I don't have an account"
                }
                .onCellSelection { [weak self] (cell, row) in
                    self?.showAlert()
            }
        
        
        // Do any additional setup after loading the view.
    }
    
    func showAlert() {
        dismiss(animated: true, completion: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func DoLogin(){
        
        
        let text = "Please wait..."
        self.showWaitOverlayWithText((text as NSString) as String)

        let url = MYWSCache.sharedInstance["RootURL" as AnyObject] as! String +  "Appointment/Login"
        
        let request = LoginRequest()
        
        let row: TextRow? = form.rowBy(tag: "uname")
        request.Username = row?.value
        let row1: PasswordRow? = form.rowBy(tag: "pword")
        request.Password = row1?.value
        
        
        let json = JSONSerializer.toJson(request)
        var apptPostData:NSDictionary = NSDictionary()
        
        do {
            apptPostData = try JSONSerializer.toDictionary(json)
            
        } catch {
            print("JSON serialization failed:  \(error)")
        }
        
        
        let obj = RestAPI()
        obj.PostAPI(url, postData: apptPostData) { response in
            self.cust = Mapper<Customer>().map(JSONString: response.rawString()!)
            if self.cust != nil{
               MYWSCache.sharedInstance.setObject(self.cust as AnyObject, forKey: "Customer" as Any as AnyObject)
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "UITabBarController") as! UITabBarController
                self.present(nextViewController, animated:true, completion:nil)
            }
            
        }
        
        // Remove everything
        self.removeAllOverlays()
        SwiftOverlays.removeAllBlockingOverlays()
        
    }
}


extension FormViewController{
    func Close() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Presentr Delegate

extension LoginViewController: PresentrDelegate {
    
    func presentrShouldDismiss(keyboardShowing: Bool) -> Bool {
        return !keyboardShowing
    }
    
}

// MARK: - UITextField Delegate

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
