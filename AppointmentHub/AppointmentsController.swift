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

//
// MARK: - Section Data Structure
//
struct Section {
    var name: String!
    var items: [String]!
    var collapsed: Bool!
    
    init(name: String, items: [String], collapsed: Bool = false) {
        self.name = name
        self.items = items
        self.collapsed = collapsed
    }
}

class MyCustomCell: UITableViewCell {
    
    @IBOutlet weak var ApptTimeLabel: UILabel!
    
    
}

//
// MARK: - View Controller
//
class AppointmentController: UIViewController, UITableViewDelegate, UITableViewDataSource,FSCalendarDataSource, FSCalendarDelegate {
    
    var refreshControl = UIRefreshControl()
    var Appts: [Appt]?
    var openSlots: [String] = []
    var selectedTime: String = ""
    var selectedDate: Date?
    var Duration: Int?
    
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
        let secondViewController = segue.destination as! ScheduleApptView
        secondViewController.selectedTime = selectedTime
        secondViewController.selectedDate = selectedDate
        
    }
    
    func GetAllAppointments(loadTable:Bool)
    {
        let text = "Please wait..."
        self.showWaitOverlayWithText((text as NSString) as String)
        
        let url = "http://appointmentslotsapi.azurewebsites.net/api/Appointment/GetAppointments"
        
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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.FSCalendar.appearance.caseOptions = [.headerUsesUpperCase,.weekdayUsesUpperCase]
        self.FSCalendar.select(self.formatter.date(from: "2016/11/22")!)
        self.FSCalendar.scope = .week
        
        self.FSCalendar.scopeGesture.isEnabled = true
        self.ApptTable.delegate = self
        self.ApptTable.dataSource = self
        GetAllAppointments(loadTable: false)
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(AppointmentController.refresh), for: UIControlEvents.valueChanged)
        self.ApptTable?.addSubview(refreshControl)
        selectedDate = Date()
        refresh()

        
    }
    
    func refresh() {
        self.GetAllAppointments(loadTable: true)
        refreshControl.endRefreshing()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        let indexPath = ApptTable.indexPathForSelectedRow
        let currentCell = tableView.cellForRow(at: indexPath!) as! MyCustomCell
        selectedTime = currentCell.ApptTimeLabel.text!
        
        self.performSegue(withIdentifier: "ShowApptScheduler", sender: self)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.openSlots.count)
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:MyCustomCell = self.ApptTable.dequeueReusableCell(withIdentifier: "CustomCell") as! MyCustomCell
        cell.ApptTimeLabel.text = openSlots[indexPath.row]
        
        return cell
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return self.formatter.date(from: "2016/11/08")!
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        return self.formatter.date(from: "2017/10/31")!
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        //let day: Int! = self.gregorian.component(.day, from: date)
        return 0  //day % 5 == 0 ? day/5 : 0;
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        NSLog("change page to \(self.formatter.string(from: calendar.currentPage))")
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date) {
        selectedDate = date
        FillSlotsArray()
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
    
    func FillSlotsArray(){
        let duration:TimeInterval = 30
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
    
    
}

