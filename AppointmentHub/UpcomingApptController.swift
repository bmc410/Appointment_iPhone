//
//  UpcomingApptControllerTableViewController.swift
//  AppointmentHub
//
//  Created by William McCoy on 12/5/16.
//  Copyright © 2016 William McCoy. All rights reserved.
//

import UIKit
import MZAppearance
import MZFormSheetPresentationController
import ObjectMapper
import Alamofire
import AlamofireObjectMapper


class ApptsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ApptTime: UILabel!

    @IBOutlet weak var SlotTime: UILabel!
}

class UpcomingApptController: UITableViewController {

    var cust:Customer?
    var appts:[Appt]?
    
    @IBAction func Login(_ sender: UIBarButtonItem) {
        passDataToViewControllerAction()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        GetAppts()
        refreshControl.endRefreshing()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cust = MYWSCache.sharedInstance["Customer" as AnyObject] as? Customer
        self.tableView.estimatedRowHeight = 280
        self.tableView.rowHeight = UITableViewAutomaticDimension
       self.refreshControl?.addTarget(self, action: #selector(UpcomingApptController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        
        if cust == nil{
            passDataToViewControllerAction()
        }
        else{
            GetAppts()
        }

        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    func passDataToViewControllerAction() {
        let navigationController = self.formSheetControllerWithNavigationController()
        let formSheetController = MZFormSheetPresentationViewController(contentViewController: navigationController)
        //formSheetController.presentationController?.shouldDismissOnBackgroundViewTap = true
        //formSheetController.presentationController?.shouldApplyBackgroundBlurEffect = true
        
        let presentedViewController = navigationController.viewControllers.first as! LoginViewController
        presentedViewController.IsFirstItem = true
        presentedViewController.ApptForm = self
        
        formSheetController.presentationController?.contentViewSize = CGSize(width:self.view.frame.width - 100, height:self.view.frame.height - 300)
        
        formSheetController.willPresentContentViewControllerHandler = { vc in
            let navigationController = vc as! UINavigationController
            let presentedViewController = navigationController.viewControllers.first as! LoginViewController
            presentedViewController.view?.layoutIfNeeded()
            //presentedViewController.textField?.text = "PASS DATA DIRECTLY TO OUTLET!!"
        }
        
        self.present(formSheetController, animated: true, completion: nil)
    }
    
    func formSheetControllerWithNavigationController() -> UINavigationController {
        return self.storyboard!.instantiateViewController(withIdentifier: "formSheetController1") as! UINavigationController
    }
    
    func GetAppts(){
        
        cust = MYWSCache.sharedInstance["Customer" as AnyObject] as? Customer
        
        if cust == nil{
            return
        }
        
        let text = "Please wait..."
        self.showWaitOverlayWithText((text as NSString) as String)
        
        let custId = cust!.CustId!
        let url = MYWSCache.sharedInstance["RootURL" as AnyObject] as! String +  "Appointment/GetAppointmentsByCustId?custId=" + String(describing: custId)
        
        let obj = RestAPI()
        obj.GetAPI(url) { response in
            self.appts = Mapper<Appt>().mapArray(JSONString: response.rawString()!)
            self.tableView.reloadData()
            SwiftOverlays.removeAllBlockingOverlays()
        }
        
        SwiftOverlays.removeAllBlockingOverlays()
        
    }

    

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if appts != nil{
            return (appts?.count)!
        }
        return 0
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ApptsTableViewCell", for: indexPath) as! ApptsTableViewCell
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let apptDate = dateFormatter.date(from: appts![indexPath.row].StartTime!)
        
        cell.ApptTime.text = apptDate?.ToString(format: "EEEE, MMMM dd yyyy")
        cell.SlotTime.text = appts![indexPath.row].StartTimeString! + " - " + appts![indexPath.row].EndTimeString!

        // Configure the cell...

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
