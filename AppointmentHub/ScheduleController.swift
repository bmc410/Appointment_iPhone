//
//  ScheduleController.swift
//  AppointmentHub
//
//  Created by William McCoy on 11/7/16.
//  Copyright © 2016 William McCoy. All rights reserved.
//

import UIKit

class ScheduleCuts : UITableViewCell {
   
    @IBOutlet weak var CutDetail: UILabel!
    @IBOutlet weak var CutTitle: UILabel!
    @IBOutlet weak var CardViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var CutCost: UILabel!
}

class ScheduleController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var CutsTable: UITableView!
    var cuts = [CutsModel]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.navigationController?.isNavigationBarHidden = true
        //self.navigationItem.title = "Seven Zero One Salon"
        
        let c0 = CutsModel()
        c0.CutName = "Mens Quick Cut"
        c0.CutDetail = "Quick trim and shape to keep that recent haircut looking great."
        c0.CutPrice = 12
        cuts.append(c0)

        
        let c = CutsModel()
        c.CutName = "Mens Basic Cut"
        c.CutDetail = "Haircut and style to create the perfect look for you."
        c.CutPrice = 16
        cuts.append(c)
        
        let c1 = CutsModel()
        c1.CutName = "Mens Premium Cut"
        c1.CutDetail = "Haircut, shampoo, beard trim and style for the men in the family."
        c1.CutPrice = 23
        cuts.append(c1)
        
        CutsTable.dataSource = self
        CutsTable.delegate = self
        
        self.view.layer.contents = UIImage(named:"background.png")!.cgImage
        
        
        

        // Do any additional setup after loading the view.
    }
    
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cuts.count
    
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //self.RxDetailTable.rowHeight = UITableViewAutomaticDimension
        //return self.RxDetailTable.rowHeight
        return 115
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //selectedItem = self.refillHist![(indexPath as NSIndexPath).row] as RefillHistory
        //self.performSegue(withIdentifier: "SlotsDetail", sender: nil)
        
    }
    
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleCuts") as? ScheduleCuts!
        cell?.CutTitle.text = cuts[(indexPath as NSIndexPath).row].CutName
        cell?.CutCost.text = "Cost: $" + String(describing: cuts[(indexPath as NSIndexPath).row].CutPrice!)
        cell?.CutDetail.text = cuts[(indexPath as NSIndexPath).row].CutDetail
        cell!.CardViewConstraint.constant = 95
        return cell!
    }
}
