//
//  HomeViewController.swift
//  AppointmentHub
//
//  Created by William McCoy on 12/8/16.
//  Copyright © 2016 William McCoy. All rights reserved.
//

import UIKit


class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        _ = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true);
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func update() {
        if let MainController = storyboard!.instantiateViewController(withIdentifier: "MainController") as? ScheduleController {
            present(MainController, animated: true, completion: nil)
        }
    }

}
