//
//  NewAccountController.swift
//  AppointmentHub
//
//  Created by William McCoy on 12/23/16.
//  Copyright © 2016 William McCoy. All rights reserved.
//

import Eureka
import ObjectMapper
import Alamofire
import AlamofireObjectMapper
import SkyFloatingLabelTextField

class NewAccountController: FormViewController {

    var cust:Customer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.hideKeyboardWhenTappedAround()

        form +++
            Section(""){$0.tag = "NewAccount"}
            
            <<< NameRow() {
                $0.title = "First Name:"
                $0.placeholder = "FirstName"
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                $0.tag = "fname"
            }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                }
            <<< NameRow() {
                $0.title = "Last Name:"
                $0.placeholder = "LastName"
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                $0.tag = "lname"
            }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                }
            <<< EmailRow() {
                $0.title = "Email:"
                $0.placeholder = "Email"
                $0.add(rule: RuleEmail())
                $0.validationOptions = .validatesOnChangeAfterBlurred
                $0.tag = "email"
            }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                }
            <<< PhoneRow() {
                $0.title = "Phone:"
                $0.placeholder = "SMS"
                $0.tag = "sms"
            }
            <<< AccountRow() {
                $0.title = "Username:"
                $0.placeholder = "Username"
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                $0.tag = "uname"
            }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                }
            <<< PasswordRow() {
                $0.title = "Password:"
                $0.placeholder = "Password"
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                $0.tag = "pword"
            }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                }
            <<< PasswordRow() {
                $0.title = "Confirm"
                $0.placeholder = "Confirm Password"
                $0.add(rule: RuleEqualsToRow(form: form, tag: "pword"))
                $0.tag = "confirmpword"
            }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
            }
            
            <<< ButtonRow() { (row: ButtonRow) -> Void in
                row.title = "Create Account"
                }
                .onCellSelection { [weak self] (cell, row) in
                    self?.SaveAccount()
            }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let row = self.form.rowBy(tag: "fname") as! NameRow
        row.cell.textField.becomeFirstResponder()
    }


    func SaveAccount(){
        
        
        self.form.validate()
        
        if self.form.validate().count > 0 {
            form.sectionBy(tag: "NewAccount")?.header?.title =  "One or more fields is invalid"
            form.sectionBy(tag: "NewAccount")?.reload()
            return
        }

        
        let text = "Please wait..."
        self.showWaitOverlayWithText((text as NSString) as String)
        
        let url = MYWSCache.sharedInstance["RootURL" as AnyObject] as! String +  "Account/SaveCustomer"
        
        let request = Customer()
        
        let savedValues = form.values(includeHidden: true)
        request?.FirstName = savedValues["fname"] as? String
        request?.LastName = savedValues["lname"] as? String
        request?.Email = savedValues["email"] as? String
        request?.Phone = savedValues["sms"] as? String
        request?.UserName = savedValues["uname"] as? String
        request?.Password = savedValues["pword"] as? String
        request?.IsEnabled = true
        
        
        let json = JSONSerializer.toJson(request ?? "")
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
                let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
                self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true);
                
            }
        }
        
        // Remove everything
        self.removeAllOverlays()
        SwiftOverlays.removeAllBlockingOverlays()
        
    }

}
