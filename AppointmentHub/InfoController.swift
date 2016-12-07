//
//  InfoController.swift
//  AppointmentHub
//
//  Created by William McCoy on 12/3/16.
//  Copyright © 2016 William McCoy. All rights reserved.
//

import UIKit
import StackViewController

class InfoController: UIViewController {
    fileprivate var stackViewController: StackViewController? = nil
    fileprivate var firstField: UIView?
    fileprivate var bodyTextView: UITextView?
    fileprivate var myView: UIView?
    
    @IBOutlet weak var MyStackView: UIStackView!
    @IBOutlet weak var ToField: LabeledTextFieldController!
    
    @IBOutlet weak var InfoView: UIView!
    
    /*
    required init(coder aDecoder: NSCoder) {
        stackViewController = StackViewController()
        stackViewController.stackViewContainer.separatorViewFactory = StackViewContainer.createSeparatorViewFactory()
        InfoView = UIView()
        super.init(nibName: nil, bundle: nil)
     
        edgesForExtendedLayout = UIRectEdge()
        //title = "Send Message"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Send", style: .done, target: self, action: #selector(InfoController.send(_:)))
    }
    */
    
    fileprivate func setupStackViewController() {
        let toFieldController = LabeledTextFieldController(labelText: "To:")
        firstField = toFieldController.view
        stackViewController?.addItem(toFieldController)
        stackViewController?.addItem(LabeledTextFieldController(labelText: "Subject:"))
        
        let textView = UITextView(frame: CGRect.zero)
        textView.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        textView.isScrollEnabled = false
        textView.textContainerInset = UIEdgeInsets(top: 15, left: 10, bottom: 0, right: 10)
        textView.text = "This field automatically expands as you type, no additional logic required"
        stackViewController?.addItem(textView, canShowSeparator: false)
        bodyTextView = textView
        
        //stackViewController.addItem(ImageAttachmentViewController())
    }
    
    override func loadView() {
        view = UIView(frame: CGRect.zero)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(InfoController.didTapView)))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let toFieldController = LabeledTextFieldController(labelText: "To:")
        firstField = toFieldController.view
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 400))
        label.text = "Hello"
        let MyStackView = UIStackView(frame: CGRect(x: 0, y: 0, width: 200, height: 400))
        MyStackView.addArrangedSubview(label)
        //self.view.addSubview(firstField!)
        //InfoView.addSubview(firstField!)
       
    }

    fileprivate func displayStackViewController() {
        addChildViewController(stackViewController!)
        myView?.addSubview((stackViewController?.view)!)
        _ = stackViewController?.view.activateSuperviewHuggingConstraints(insets: .init(top: 0, left: 0, bottom: 0, right: 0))
        stackViewController?.didMove(toParentViewController: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        firstField?.becomeFirstResponder()
    }
    
    // MARK: Actions
    
    @objc fileprivate func send(_ sender: UIBarButtonItem) {}
    
    @objc fileprivate func didTapView(_ gestureRecognizer: UIGestureRecognizer) {
        bodyTextView?.becomeFirstResponder()
    }
}
