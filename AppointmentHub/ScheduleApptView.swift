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
import MZAppearance
import MZFormSheetPresentationController

class ScheduleApptView: UIViewController {
    
    var selectedTime: String = ""
    var selectedDate: Date?
    var request:AppointmentRequest = AppointmentRequest()
    var duration:Int?
    var StartDateString: String?
    var EndDateString:String?
    var dFormatString = "MM/d/yyyy h:mm a"
    var cust:Customer?
    
    var CutTimeVar:String?
    var CutDateVar:String?
    var CutNameVar:String?
    var CutTypeID:Int?
    
    
      
    @IBOutlet weak var CutType: UILabel!
    @IBOutlet weak var CutDate: UILabel!
    @IBOutlet weak var CutTime: UILabel!
    
       
    @IBOutlet weak var DateTimeLabel: UILabel!
    @IBAction func ScheduleAppointment(_ sender: UIButton) {
        
        cust = MYWSCache.sharedInstance["Customer" as AnyObject] as? Customer
        
        if cust == nil{
            performSegue(withIdentifier: "LoginSegue", sender: nil)
        }
        else{
            Schedule()
        }
        
    }
    
    
    func FormatDateTimeString() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/d/yyyy"
        let dateString = formatter.string(from: selectedDate!)
        StartDateString = dateString + " " + selectedTime
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dFormatString
        let startDate = dateFormatter.date(from: StartDateString!)
        let endDate = startDate?.add(minutes: duration!)
        
        EndDateString = endDate?.ToString(format: dFormatString)
        
    }
    
    func backTwo() {
        
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true);
        
    }
    
    func PopController(alert: UIAlertAction!) {
        backTwo()
    }
    
    func customContentViewSizeAction() {
        let navigationController = self.formSheetControllerWithNavigationController()
        let formSheetController = MZFormSheetPresentationViewController(contentViewController: navigationController)
        formSheetController.presentationController?.contentViewSize = CGSize(width:self.view.frame.width - 100, height:self.view.frame.height - 300)
        
        self.present(formSheetController, animated: true, completion: nil)
    }
    
    func formSheetControllerWithNavigationController() -> UINavigationController {
        return self.storyboard!.instantiateViewController(withIdentifier: "formSheetController") as! UINavigationController
    }
    
    func closeHandler(alert: UIAlertAction!) {
        self.dismiss(animated: true, completion: nil)
    }

    
    private func Schedule(){
        
        let url = MYWSCache.sharedInstance["RootURL" as AnyObject] as! String +  "Appointment/ScheduleAppointment"
        var actions: [UIAlertAction] = [UIAlertAction]()
        actions.append(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: closeHandler ))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dFormatString
        
         _ = FormatDateTimeString()
        
        
        request.AppointmentType = CutTypeID
        request.StartDateTime = StartDateString
        request.EndDateTime = EndDateString
        request.CustId = cust?.CustId
        
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
    
    func closeForm() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CutDate.text = CutDateVar
        CutTime.text = CutTimeVar
        CutType.text = CutNameVar
        
         self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "close"), style: .plain, target: self, action: #selector(ScheduleApptView.closeForm))
        
        self.navigationItem.title = "Confirm Appointment"
        
        /*
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        let dateString = formatter.string(from: selectedDate!)
        DateTimeLabel.text = "You are scheduling an appointment for " + dateString + " at " + selectedTime
        
        cust = MYWSCache.sharedInstance.object(forKey: "Customer" as AnyObject) as? Customer
        FirstName.text = cust?.FirstName
        LastName.text = cust?.LastName
 */
    }
}
