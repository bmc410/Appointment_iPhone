//
//  ScheduleController.swift
//  AppointmentHub
//
//  Created by William McCoy on 11/7/16.
//  Copyright © 2016 William McCoy. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class ScheduleCuts : UITableViewCell {
   
    @IBOutlet weak var CutDetail: UILabel!
    @IBOutlet weak var CutTitle: UILabel!
    @IBOutlet weak var CardViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var CutCost: UILabel!
}

class ScheduleController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var HomeImage: UIImageView!
    
    @IBOutlet weak var ScheduleLabel: UILabel!
    
    
    @IBOutlet weak var CutsTable: UITableView!
    var cuts = [CutsModel]()
    var duration:Int?
    var ApptTypes: [ApptType]?
    var CutsName:String?
    var CutsType:Int?
    var secondViewController:AppointmentController?

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // get a reference to the second view controller
        secondViewController = segue.destination as? AppointmentController
        
        
    }

    func GetApptTypes(){
        let text = "Please wait..."
        self.showWaitOverlayWithText((text as NSString) as String)
        
        
        let url = MYWSCache.sharedInstance["RootURL" as AnyObject] as! String +  "Appointment/GetApptTypes"
        
        let obj = RestAPI()
        obj.GetAPI(url) { response in
            self.ApptTypes = Mapper<ApptType>().mapArray(JSONString: response.rawString()!)
            
            for a in self.ApptTypes!{
                let c = CutsModel()
                c.CutName = a.ApptType
                c.CutDetail = a.ApptDescription
                c.CutPrice = a.ApptPrice
                c.CutTime = a.ApptLength
                c.CutTypeID = a.ApptTypeID
                self.cuts.append(c)
            }
            self.CutsTable.reloadData()
            
            self.removeAllOverlays()
            self.HomeImage.isHidden = true
            self.ScheduleLabel.isHidden = false
            self.CutsTable.separatorStyle = .singleLine
            SwiftOverlays.removeAllBlockingOverlays()
            
            MYWSCache.sharedInstance.setObject(self.ApptTypes as AnyObject, forKey: "ApptTypes" as AnyObject)
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        HomeImage.isHidden = false
        CutsTable.separatorStyle = .none
        let path = Bundle.main.path(forResource: "Info", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!)
        let url: AnyObject = dict!.object(forKey: "RootURL") as AnyObject
        MYWSCache.sharedInstance.setObject(url as AnyObject, forKey: "RootURL" as AnyObject)
        
        GetApptTypes()
        
        CutsTable.dataSource = self
        CutsTable.delegate = self
        CutsTable.rowHeight = UITableViewAutomaticDimension
        CutsTable.estimatedRowHeight = 140
        
        //self.view.layer.contents = UIImage(named:"background.png")!.cgImage
        
        
        

        // Do any additional setup after loading the view.
    }
    
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cuts.count
    
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        self.CutsTable.rowHeight = UITableViewAutomaticDimension
        return self.CutsTable.rowHeight
        //return 100
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        duration = cuts[indexPath.row].CutTime
        CutsName = cuts[indexPath.row].CutName
        CutsType = cuts[indexPath.row].CutTypeID
        secondViewController?.Duration = duration
        secondViewController?.CutName = CutsName
        secondViewController?.CutType = CutsType

        
        //selectedItem = self.refillHist![(indexPath as NSIndexPath).row] as RefillHistory
        //self.performSegue(withIdentifier: "SlotsDetail", sender: nil)
        
    }
    
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleCuts") as? ScheduleCuts!
        cell?.CutTitle.text = cuts[(indexPath as NSIndexPath).row].CutName
        cell?.CutCost.text = "Cost: $" + String(describing: cuts[(indexPath as NSIndexPath).row].CutPrice!)
        cell?.CutDetail.text = cuts[(indexPath as NSIndexPath).row].CutDetail
        
        return cell!
    }
}
