//
//  CollapsibleTableViewController.swift
//  ios-swift-collapsible-table-section
//
//  Created by Yong Su on 5/30/16.
//  Copyright © 2016 Yong Su. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire
import AlamofireObjectMapper
import MZAppearance
import MZFormSheetPresentationController

//
// MARK: - Section Data Structure
//

class MyCustomCell: UITableViewCell {
    
    @IBOutlet weak var ApptTimeLabel: UILabel!
    
    
}

//
// MARK: - View Controller
//
class AppointmentController: UIViewController, UITableViewDelegate, UITableViewDataSource,FSCalendarDataSource, FSCalendarDelegate {
    
    var refreshControl = UIRefreshControl()
    var Appts: [Appt]?
    var Slots: [SlotModel]?
    var SelectedDaySlots: [SlotModel] = [SlotModel]()
    var openSlots: [String] = []
    var selectedTime: String = ""
    var selectedDate: Date?
    var Duration: Int?
    var CutName:String?
    var CutType:Int?
    
    @IBOutlet weak var FSCalendar: FSCalendar!
    
    @IBOutlet weak var ApptTable: UITableView!
    @IBOutlet weak var FSHeightConstraint: NSLayoutConstraint!
    
    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter}()
    
    private let gregorian: NSCalendar! = NSCalendar(calendarIdentifier:NSCalendar.Identifier.gregorian)
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // get a reference to the second view controller
        //let secondViewController = segue.destination as! ScheduleApptView
        //secondViewController.selectedTime = selectedTime
        //secondViewController.selectedDate = selectedDate
        
    }
    
    func passDataToViewControllerAction() {
        let navigationController = self.formSheetControllerWithNavigationController()
        let formSheetController = MZFormSheetPresentationViewController(contentViewController: navigationController)
        //formSheetController.presentationController?.shouldDismissOnBackgroundViewTap = true
        //formSheetController.presentationController?.shouldApplyBackgroundBlurEffect = true
        
        let presentedViewController = navigationController.viewControllers.first as! ScheduleApptView
        presentedViewController.CutTimeVar = selectedTime
        presentedViewController.CutDateVar = selectedDate?.ToString(format: "EEEE, MMMM d")
        presentedViewController.CutTypeID = CutType
        presentedViewController.CutNameVar = CutName
        presentedViewController.selectedDate = selectedDate
        presentedViewController.selectedTime = selectedTime
        presentedViewController.duration = Duration
        presentedViewController.ApptCtrl = self
        
        
         formSheetController.presentationController?.contentViewSize = CGSize(width:self.view.frame.width - 100, height:self.view.frame.height - 280)
        
        formSheetController.willPresentContentViewControllerHandler = { vc in
            let navigationController = vc as! UINavigationController
            let presentedViewController = navigationController.viewControllers.first as! ScheduleApptView
            presentedViewController.view?.layoutIfNeeded()
            //presentedViewController.textField?.text = "PASS DATA DIRECTLY TO OUTLET!!"
        }
        
        self.present(formSheetController, animated: true, completion: nil)
    }
    
    
    func formSheetControllerWithNavigationController() -> UINavigationController {
        return self.storyboard!.instantiateViewController(withIdentifier: "formSheetController") as! UINavigationController
    }

    
    /*
    func GetAllAppointments(loadTable:Bool)
    {
        let text = "Please wait..."
        self.showWaitOverlayWithText((text as NSString) as String)
        
        let url = MYWSCache.sharedInstance["RootURL" as AnyObject] as! String +  "Appointment/GetAppointments"
        
        let obj = RestAPI()
        obj.GetAPI(url) { response in
            self.Appts = Mapper<Appt>().mapArray(JSONString: response.rawString()!)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            for a in self.Appts!{
                a.ApptDate = dateFormatter.date(from: a.StartTime!)
            }
            if loadTable{
                self.FillSlotsArray()
            }
            // Remove everything
            self.removeAllOverlays()
            SwiftOverlays.removeAllBlockingOverlays()
            MYWSCache.sharedInstance.setObject(self.Appts as AnyObject, forKey: "Appts" as AnyObject)
        }
    }
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MZTransition.registerClass(ScheduleApptView.self, for: .custom)
        self.FSCalendar.appearance.caseOptions = [.headerUsesUpperCase,.weekdayUsesUpperCase]
        self.FSCalendar.select(self.formatter.date(from: Date().ToString(format: "yyyy/MM/dd"))!)
        self.FSCalendar.scope = .week
        
        GetAvailableSlots()
        
        self.FSCalendar.scopeGesture.isEnabled = true
        self.ApptTable.delegate = self
        self.ApptTable.dataSource = self
        //GetAllAppointments(loadTable: false)
        
        
        
        //refreshControl.attributedTitle = NSAttributedString(string: "Refreshing")
        refreshControl.addTarget(self, action: #selector(AppointmentController.refresh), for: UIControlEvents.valueChanged)
        self.ApptTable?.addSubview(refreshControl)
        selectedDate = Date()
        //refresh()

        
    }
    
    func refresh() {
        GetAvailableSlots()
        // update "last updated" title for refresh control
        let df = DateFormatter()
        df.dateStyle = .short
        df.timeStyle = .long
        let now = NSDate()
        let updateString = "Last Updated at " + df.string(from: now as Date)
        self.refreshControl.attributedTitle = NSAttributedString(string: updateString)
        if self.refreshControl.isRefreshing
        {
            self.refreshControl.endRefreshing()
        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        let indexPath = ApptTable.indexPathForSelectedRow
        let currentCell = tableView.cellForRow(at: indexPath!) as! MyCustomCell
        selectedTime = currentCell.ApptTimeLabel.text!
        
        passDataToViewControllerAction()
        //customContentViewSizeAction()
        //self.performSegue(withIdentifier: "ShowApptScheduler", sender: self)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.SelectedDaySlots == nil {
            return 0
        }
        else {
            return (self.SelectedDaySlots.count)
        }
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:MyCustomCell = self.ApptTable.dequeueReusableCell(withIdentifier: "CustomCell") as! MyCustomCell
        if self.SelectedDaySlots.count == 0{
            return cell
        }
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "h:mm a"
        let time = formatter.string(from: (SelectedDaySlots[indexPath.row].dtStartSlot)!)
        cell.ApptTimeLabel.text = time
        
        return cell
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        let EndDateString = Date().ToString(format: "yyyy/MM/dd")
        return self.formatter.date(from: EndDateString)!
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        var components = DateComponents()
        components.setValue(2, for: .month)
        let date: Date = Date()
        let expirationDate = Calendar.current.date(byAdding: components, to: date)
        //let twoWeeks = Date().add(minutes: 20160)
        let EndDateString = expirationDate?.ToString(format: "yyyy/MM/dd")
        
        //let EndDateString = twoWeeks.ToString(format: "yyyy/MM/dd")
        return self.formatter.date(from: EndDateString!)!
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        //let day: Int! = self.gregorian.component(.day, from: date)
        return 0  //day % 5 == 0 ? day/5 : 0;
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        NSLog("change page to \(self.formatter.string(from: calendar.currentPage))")
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date) {
        let lastRefreshed = MYWSCache.sharedInstance["LastRefreshed" as AnyObject] as! Date
        let calendar = NSCalendar.current
        let unitFlags = Set<Calendar.Component>([.second])
        let anchorComponents = calendar.dateComponents(unitFlags, from: lastRefreshed as Date,  to: Date() as Date)
        if(anchorComponents.second! > 30){
            GetAvailableSlots()
            return
        }
        
        
        selectedDate = date
        self.SelectedDaySlots.removeAll()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        for a in self.Slots!{
            //let d = dateFormatter.date(from: a.StartSlot!)
            a.dtStartSlot = dateFormatter.date(from: a.StartSlot!)
            a.dtEndSlot = dateFormatter.date(from: a.EndSlot!)
            if NSCalendar.current.isDate(a.dtStartSlot!, inSameDayAs: FSCalendar.selectedDate){
                self.SelectedDaySlots.append(a)
            }
        }
        
        self.ApptTable.reloadData()

        //FillSlotsArray()
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        FSHeightConstraint.constant = bounds.height
        view.layoutIfNeeded()
    }

    
    func convertDateFormater(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let dateString = dateFormatter.string(from: date as Date)
        return (dateString)
    }
    
    
    func GetAvailableSlots()
    {
        let request:SlotsRequest = SlotsRequest()
        self.SelectedDaySlots.removeAll()
        self.Slots?.removeAll()
        request.apptLength = 30
        request.daysToGet = 30
        request.duration = 15
        
        let json = JSONSerializer.toJson(request)
        var slotPostData:NSDictionary = NSDictionary()
        
        do {
            slotPostData = try JSONSerializer.toDictionary(json)
            
        } catch {
            print("JSON serialization failed:  \(error)")
        }
        
        let url = MYWSCache.sharedInstance["RootURL" as AnyObject] as! String +  "Appointment/GetSlots"
        

        let obj = RestAPI()
        obj.PostAPI(url, postData: slotPostData) { response in
            self.Slots = Mapper<SlotModel>().mapArray(JSONString: response.rawString()!)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            
            for a in self.Slots!{
                //let d = dateFormatter.date(from: a.StartSlot!)
                a.dtStartSlot = dateFormatter.date(from: a.StartSlot!)
                a.dtEndSlot = dateFormatter.date(from: a.EndSlot!)
                if NSCalendar.current.isDate(a.dtStartSlot!, inSameDayAs: self.FSCalendar.selectedDate){
                    self.SelectedDaySlots.append(a)
                }
            }
            
            self.ApptTable.reloadData()
        }
        MYWSCache.sharedInstance.setObject(Date() as AnyObject, forKey: "LastRefreshed" as AnyObject)
        

        
    }
    
    /*
    func FillSlotsArray(){
        let d:Double = Double(Duration!)
        let duration:TimeInterval = d
        let time = Time(startHour: 8, intervalMinutes: duration, endHour: 18)
        let array = time.timeRepresentations
        let dateFormatter = DateFormatter()
        
        self.openSlots.removeAll()
        
        let calendar = NSCalendar.autoupdatingCurrent
        
        let t = self.Appts?.filter({$0.ApptDate != nil && calendar.isDate($0.ApptDate!, inSameDayAs: selectedDate!)})
        print(t ?? "Test")
        
        for twelve in array {
            dateFormatter.dateFormat = "H:mm"
            if let date12 = dateFormatter.date(from: twelve) {
                dateFormatter.dateFormat = "h:mm a"
                let date22 = dateFormatter.string(from: date12)
                let s = t?.filter({$0.StartTimeString == date22})
                if s?.count == 0{
                    self.openSlots.append(date22)
                }
            } else {
                // oops, error while converting the string
            }
            
        }
        ApptTable.reloadData()
    }
    */
    
}

