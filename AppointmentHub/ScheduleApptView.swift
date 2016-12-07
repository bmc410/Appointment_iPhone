//
//  ScheduleApptView.swift
//  AppointmentHub
//
//  Created by William McCoy on 11/20/16.
//  Copyright © 2016 William McCoy. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import StackViewController
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class ScheduleApptView: UIViewController {
    
    var selectedTime: String = ""
    var selectedDate: Date?
    var request:AppointmentRequest = AppointmentRequest()
    var duration:Int?
    var StartDateString: String?
    var EndDateString:String?
    var dFormatString = "MM/d/yyyy h:mm a"
    
    @IBAction func FindMe(_ sender: Any) {
        GetCustomer(PINCode: PINCode.text!)
    }
    
    @IBOutlet weak var PINCode: SkyFloatingLabelTextField!
    @IBOutlet weak var InfoStackView: StackViewController!
    @IBOutlet var FirstName: SkyFloatingLabelTextField!
    @IBOutlet var LastName: SkyFloatingLabelTextField!
    @IBOutlet var Email: SkyFloatingLabelTextField!
    @IBOutlet var Phone: SkyFloatingLabelTextField!
    
    
       
    @IBOutlet weak var DateTimeLabel: UILabel!
    @IBAction func ScheduleAppointment(_ sender: UIButton) {
        Schedule()
    }
    
    
    func GetCustomer(PINCode:String)
    {
        let text = "Please wait..."
        self.showWaitOverlayWithText((text as NSString) as String)
        
        let url = MYWSCache.sharedInstance["RootURL" as AnyObject] as! String +  "Appointment/GetCustomerByPin?PINCode=" + PINCode
        
        let obj = RestAPI()
        obj.GetAPI(url) { response in
            let user = Mapper<Customer>().map(JSON: response.rawValue as! [String : Any])
            self.FirstName.text = user?.FirstName
            self.LastName.text = user?.LastName
            self.Email.text = user?.Email
            self.Phone.text = user?.Phone
        }
        
        // Remove everything
        self.removeAllOverlays()
        SwiftOverlays.removeAllBlockingOverlays()
        
    }

    
    func FormatDateTimeString() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/d/yyyy"
        let dateString = formatter.string(from: selectedDate!)
        StartDateString = dateString + " " + selectedTime
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dFormatString
        let startDate = dateFormatter.date(from: dateString)
        let endDate = startDate?.add(minutes: 30)
        
        EndDateString = endDate?.ToString(format: dFormatString)
        
    }
    
    func backTwo() {
        
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true);
        
    }
    
    func PopController(alert: UIAlertAction!) {
        backTwo()
    }
    
    private func Schedule(){
        let url = MYWSCache.sharedInstance["RootURL" as AnyObject] as! String +  "Appointment/ScheduleAppointment"
        var actions: [UIAlertAction] = [UIAlertAction]()
        actions.append(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: self.PopController))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dFormatString
        
         _ = FormatDateTimeString()
        
        
        request.AppointmentType = 1
        request.StartDateTime = StartDateString
        request.EndDateTime = EndDateString
        request.FirstName = FirstName.text
        request.LastName = LastName.text
        request.Email = Email.text
        request.Phone = Phone.text
        
        let json = JSONSerializer.toJson(request)
        var apptPostData:NSDictionary = NSDictionary()
        
        do {
            apptPostData = try JSONSerializer.toDictionary(json)
            
        } catch {
            print("JSON serialization failed:  \(error)")
        }
        
        
        let obj = RestAPI()
        obj.PostAPI(url, postData: apptPostData) { response in
            Common.ShowAlert(self, Message: "Submitted successfully.", Actions: actions, Title: "")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        let dateString = formatter.string(from: selectedDate!)
        DateTimeLabel.text = "You are scheduling an appointment for " + dateString + " at " + selectedTime
        
    }
    
}
