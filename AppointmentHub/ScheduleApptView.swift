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
import UserNotifications
import UserNotificationsUI
import KMPlaceholderTextView



class ScheduleApptView: UIViewController,UITextFieldDelegate {
    
    let requestIdentifier = "SampleRequest"
    var selectedTime: String = ""
    var selectedDate: Date?
    var request:AppointmentRequest = AppointmentRequest()
    var duration:Int?
    var StartDateString: String?
    var EndDateString:String?
    var dFormatString = "MM/d/yyyy h:mm a"
    var cust:Customer?
    var apptResp:AppointmentResponse?
    
    var CutTimeVar:String?
    var CutDateVar:String?
    var CutNameVar:String?
    var CutTypeID:Int?
    var gameTimer: Timer!
    var ApptCtrl: AppointmentController?
    
    @IBOutlet weak var CommentTV: KMPlaceholderTextView!
    
    
      
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
    
    func triggerNotification(body:String){
        
        _ = ProcessInfo.processInfo.globallyUniqueString
        
        let content = UNMutableNotificationContent()
        content.title = "Scheduline Confirmation"
        content.subtitle = "Appointment was scheduled successfully"
        content.body = body
        content.sound = UNNotificationSound.default()
        
        /*
        if let attachment = UNNotificationAttachment.create(identifier: identifier, image: UIImage(named: "logo")!, options: nil) {
            // where myImage is any UIImage that follows the
            content.attachments = [attachment]
        }
         */
        
        // Deliver the notification in five seconds.
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 0.1, repeats: false)
        let request = UNNotificationRequest(identifier:requestIdentifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().add(request){(error) in
            
            if (error != nil){
                
                print(error?.localizedDescription ?? "")
            }
        }
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
        
    }
    
    func runTimedCode() {
        self.closeForm()
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
        formSheetController.presentationController?.contentViewSize = CGSize(width:self.view.frame.width - 100, height:self.view.frame.height - 280)
        
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
        let actions: [UIAlertAction] = [UIAlertAction]()
        //actions.append(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: closeHandler ))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dFormatString
        
         _ = FormatDateTimeString()
        
        
        
        
        request.AppointmentType = CutTypeID
        request.ApptDateTime = StartDateString
        request.Duration = duration
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
            self.apptResp = Mapper<AppointmentResponse>().map(JSONString: response.rawString()!)
            if self.apptResp?.IsSussessful == true{
                let body = "Your appointment on " + self.CutDateVar! + " at " + self.CutTimeVar! + " was scheduled successfully."
                self.triggerNotification(body: body)
                self.ApptCtrl?.GetAvailableSlots()
                //self.closeForm()
            }
            else{
                Common.ShowAlert(self, Message: "There was a problem with your request. Please try again later", Actions: actions, Title: "")
            }
            
        }
    }
    
    func closeForm() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()

        
        CutDate.text = CutDateVar
        CutTime.text = CutTimeVar
        CutType.text = CutNameVar
        
         self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "close"), style: .plain, target: self, action: #selector(ScheduleApptView.closeForm))
        
        self.navigationItem.title = "Confirm Appointment"
               //CommentTV.becomeFirstResponder()
        //CommentTV.returnKeyType = UIReturnKeyType.done
        
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
