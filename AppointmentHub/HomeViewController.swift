//
//  HomeViewController.swift
//  AppointmentHub
//
//  Created by William McCoy on 12/8/16.
//  Copyright © 2016 William McCoy. All rights reserved.
//

import UIKit
import Presentr

class HomeViewController: UIViewController {

    
    @IBAction func Login(_ sender: UIButton) {
        popupDefault()
    }
    
    var presenter: Presentr = {
        let presenter = Presentr(presentationType: .alert)
        presenter.transitionType = TransitionType.coverHorizontalFromRight
        return presenter
    }()
    
    func popupDefault() {
        presenter.presentationType = .popup
        
        presenter.transitionType = nil
        presenter.dismissTransitionType = nil
        presenter.roundCorners = true
        presenter.cornerRadius = 10
        
        presenter.dismissAnimated = true
        customPresentViewController(presenter, viewController: popupViewController, animated: true, completion: nil)
    }
    
    lazy var popupViewController: LoginViewController = {
        let popupViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
        return popupViewController as! LoginViewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let path = Bundle.main.path(forResource: "Info", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!)
        let url: AnyObject = dict!.object(forKey: "RootURL") as AnyObject
        MYWSCache.sharedInstance.setObject(url as AnyObject, forKey: "RootURL" as AnyObject)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
