//
//  RecurringAppointmentController.swift
//  AppointmentHub
//
//  Created by William McCoy on 1/8/17.
//  Copyright © 2017 William McCoy. All rights reserved.
//

import UIKit
import MZAppearance
import MZFormSheetPresentationController

class RecurringAppointmentController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var RecurStartDateField: UITextField!
    var datePicker : UIDatePicker!
    var freqpickerView : UIPickerView!
    var apptTypepickerView : UIPickerView!
    var cust:Customer?
    
    let frequency = ["Every Week", "Every Other Week", "Once A Month"]
    let apptTypes = MYWSCache.sharedInstance["ApptTypes" as AnyObject] as! [ApptType]
    
    @IBAction func RecurStartDateEditing(_ sender: UITextField) {
       self.pickUpDate(textField: self.RecurStartDateField)
    }
    
    @IBOutlet weak var FrequencyField: UITextField!
    
    @IBAction func FrequencyEditing(_ sender: UITextField) {
        //pickFrequency(textField: self.FrequencyField)
    }
    
    @IBOutlet weak var RecurTimeField: UITextField!
    
    @IBAction func RecurStartTimeEditing(_ sender: UITextField) {
        self.pickUpTime(textField: self.RecurTimeField)
    }
    
    @IBOutlet weak var ApptTypeField: UITextField!
    
    func Login() {
        if self.navigationItem.rightBarButtonItem?.title == "Login" {
            passDataToViewControllerAction()
        }
        else{
            self.cust = nil
            MYWSCache.sharedInstance.setObject(self.cust as AnyObject, forKey: "Customer" as Any as AnyObject)
            self.navigationItem.rightBarButtonItem?.title = "Login"
            
        }
    }

    
    
    func pickApptType(textField : UITextField){
        
        // DatePicker
        self.apptTypepickerView = UIPickerView()
        //self.frequencypickerView.backgroundColor = UIColor.white
        textField.inputView = self.apptTypepickerView
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(RecurringAppointmentController.cancelDoneApptTypeClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(RecurringAppointmentController.cancelDoneApptTypeClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
    }

    
    func pickFrequency(textField : UITextField){
        
        // DatePicker
        self.freqpickerView = UIPickerView()
        //self.frequencypickerView.backgroundColor = UIColor.white
        textField.inputView = self.freqpickerView
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(RecurringAppointmentController.cancelDoneFrequencyClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(RecurringAppointmentController.cancelDoneFrequencyClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
    }

    
    func pickUpTime(textField : UITextField){
        
        // DatePicker
        self.datePicker = UIDatePicker()
        self.datePicker.backgroundColor = UIColor.white
        self.datePicker.datePickerMode = UIDatePickerMode.time
        self.datePicker.minuteInterval = 30
        textField.inputView = self.datePicker
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(RecurringAppointmentController.doneTimeClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(RecurringAppointmentController.cancelTimeClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
    }

    
    
    func pickUpDate(textField : UITextField){
        
        // DatePicker
        self.datePicker = UIDatePicker()
        self.datePicker.backgroundColor = UIColor.white
        self.datePicker.datePickerMode = UIDatePickerMode.date
        textField.inputView = self.datePicker
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(RecurringAppointmentController.doneDateClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(RecurringAppointmentController.cancelDateClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
    }
    func cancelDoneFrequencyClick() {
        if FrequencyField.text == ""{
            FrequencyField.text = frequency[freqpickerView.selectedRow(inComponent: 0)]
        }
        FrequencyField.resignFirstResponder()
    }
    func cancelDoneApptTypeClick() {
        if ApptTypeField.text == ""{
            ApptTypeField.text = apptTypes[apptTypepickerView.selectedRow(inComponent: 0)].ApptType
        }
        ApptTypeField.resignFirstResponder()
    }
    
    
    func doneDateClick() {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateStyle = .long
        dateFormatter1.timeStyle = .none
        RecurStartDateField.text = dateFormatter1.string(from: datePicker.date)
        RecurStartDateField.resignFirstResponder()
    }
    func cancelDateClick() {
        RecurStartDateField.resignFirstResponder()
    }
    func doneTimeClick() {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateStyle = .none
        dateFormatter1.timeStyle = .short
        RecurTimeField.text = dateFormatter1.string(from: datePicker.date)
        RecurTimeField.resignFirstResponder()
    }
    func cancelTimeClick() {
        RecurStartDateField.resignFirstResponder()
    }

    
    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = .medium
        
        dateFormatter.timeStyle = .none
        
        RecurStartDateField.text = dateFormatter.string(from: sender.date)
        
    }
    
    func passDataToViewControllerAction() {
        let navigationController = self.formSheetControllerWithNavigationController()
        let formSheetController = MZFormSheetPresentationViewController(contentViewController: navigationController)
        //formSheetController.presentationController?.shouldDismissOnBackgroundViewTap = true
        //formSheetController.presentationController?.shouldApplyBackgroundBlurEffect = true
        
        let presentedViewController = navigationController.viewControllers.first as! LoginViewController
        presentedViewController.IsFirstItem = true
        //presentedViewController.ApptForm = self
        
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sendButton = UIBarButtonItem(title: "Login", style: UIBarButtonItemStyle.plain, target: self, action: #selector(RecurringAppointmentController.Login))
        
        self.navigationItem.setRightBarButton(sendButton, animated: true)
        
        cust = MYWSCache.sharedInstance["Customer" as AnyObject] as? Customer
        if cust == nil{
            self.view.viewWithTag(1)?.isHidden = true
            self.view.viewWithTag(2)?.isHidden = false
            passDataToViewControllerAction()
        }
        else{
            self.view.viewWithTag(1)?.isHidden = false
            self.view.viewWithTag(2)?.isHidden = true
        }

        
        pickFrequency(textField: self.FrequencyField)
        pickApptType(textField: self.ApptTypeField)
        freqpickerView.dataSource = self
        freqpickerView.delegate = self
        apptTypepickerView.dataSource = self
        apptTypepickerView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
       return 1
    }
    
    
    // returns the # of rows in each component..
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if pickerView == freqpickerView{
            return frequency.count
        }
        else{
            return apptTypes.count
        }
    }


    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == freqpickerView{
            return frequency[row]
        }
        else{
            return apptTypes[row].ApptType
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if pickerView == freqpickerView{
            FrequencyField.text = "\(frequency[row])"
        }
        else{
            ApptTypeField.text = apptTypes[row].ApptType
        }
        
    }
}
