//
//  PopupViewController.swift
//  PresentrExample
//
//  Created by Daniel Lozano on 8/29/16.
//  Copyright © 2016 danielozano. All rights reserved.
//

import UIKit
import Eureka
import ObjectMapper
import Alamofire
import AlamofireObjectMapper
import SkyFloatingLabelTextField

class LoginViewController: FormViewController {

    var cust:Customer?
    var IsFirstItem:Bool = false
    var ApptForm:UpcomingApptController?
    
    func closeForm() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Login"
        if IsFirstItem{
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "close"), style: .plain, target: self, action: #selector(LoginViewController.closeForm))

        }
        
        //self.hideKeyboardWhenTappedAround()
        
        form +++
            
            Section(""){$0.tag = "Login"}
            
            <<< AccountRow() {
                $0.title = "Login:"
                $0.placeholder = "Username"
                $0.tag = "uname"
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
            }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                }

            
            <<< PasswordRow() {
                $0.title = "Password:"
                $0.placeholder = "Password"
                $0.tag = "pword"
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
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
                    self?.performSegue(withIdentifier: "NewAccountSegue", sender: nil)
            }
        
        form.allSections[0].tag = "Login"
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let row = self.form.rowBy(tag: "uname") as! AccountRow
        row.cell.textField.becomeFirstResponder()
    }

    
    func Dismiss() {
        dismiss(animated: true, completion: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func DoLogin(){
        
        self.form.validate()
        
        if self.form.validate().count > 0 {
            form.sectionBy(tag: "Login")?.header?.title =  "One or more fields is invalid"
            form.sectionBy(tag: "Login")?.reload()
            return
        }
        
        let text = "Please wait..."
        self.showWaitOverlayWithText((text as NSString) as String)

        let url = MYWSCache.sharedInstance["RootURL" as AnyObject] as! String +  "Account/Login"
        
        let request = LoginRequest()
        
        let row: AccountRow? = form.rowBy(tag: "uname")
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
            if self.cust != nil && self.cust?.CustId != nil{
               MYWSCache.sharedInstance.setObject(self.cust as AnyObject, forKey: "Customer" as Any as AnyObject)
                
                if self.IsFirstItem{
                    self.ApptForm?.GetAppts()
                    self.navigationItem.rightBarButtonItem?.title = "LogOut"
                    self.Dismiss()
                }
                else{
                    let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
                    self.navigationController!.popToViewController(viewControllers[viewControllers.count - 2], animated: true);
 
                }
                
            }
            else{
                let row: AccountRow? = self.form.rowBy(tag: "uname")
                row?.cell.titleLabel?.textColor = .red
                let row1: PasswordRow? = self.form.rowBy(tag: "pword")
                row1?.cell.titleLabel?.textColor = .red
                self.form.allSections[1].footer?.title = "Login Error"
                
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



// MARK: - UITextField Delegate

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
