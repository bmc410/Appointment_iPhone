//
//  ScheduleApptView.swift
//  AppointmentHub
//
//  Created by William McCoy on 11/20/16.
//  Copyright © 2016 William McCoy. All rights reserved.
//

import UIKit

class ScheduleApptView: UIViewController {
    
    var selectedTime: String = ""
    var selectedDate: Date?
    var request:AppointmentRequest = AppointmentRequest()
    
       
    @IBOutlet weak var DateTimeLabel: UILabel!
    @IBAction func ScheduleAppointment(_ sender: UIButton) {
        Schedule()
    }
    
    func PopController(alert: UIAlertAction!) {
        //reload the previous view
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    private func Schedule(){
        let url = "http://appointmentslotsapi.azurewebsites.net/api/Appointment/ScheduleAppointment"
        var actions: [UIAlertAction] = [UIAlertAction]()
        actions.append(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: self.PopController))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/d/yyyy hh:mm a"
        
        request.AppointmentType = 1
        request.StartDateTime = "12/3/2016 10:00 AM"
        request.EndDateTime = "12/3/2016 10:30 AM"
        request.FirstName = "Bill"
        request.LastName = "McCoy"
        request.Email = "bmc410@comcast.net"
        request.Phone = "968-6075"
        
        let json = JSONSerializer.toJson(request)
        var apptPostData:NSDictionary = NSDictionary()
        
        do {
            apptPostData = try JSONSerializer.toDictionary(json)
            
        } catch {
            print("JSON serialization failed:  \(error)")
        }
        
        
        let obj = RestAPI()
        obj.PostAPI(url, postData: apptPostData) { response in
            Common.ShowAlert(self, Message: "Submitted successfully. Please check back for a status update.", Actions: actions, Title: "")
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
