//
//  Helper.swift
//  ModalDialogExample
//
//  Created by Bill McCoy on 12/8/16.
//  Copyright © 2016 William McCoy. All rights reserved.
//

import UIKit
import Presentr
import Eureka

public class Helper{
    public static func CreateSection(MyView:FormViewController, title:String) -> Section{
        let section = Section()
        var header = HeaderFooterView<UIView>(.callback({
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
            view.backgroundColor = .lightText
            let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: MyView.view.frame.width, height: 44))
            view.addSubview(navBar);
            let navItem = UINavigationItem();
            navItem.title = title
            
            let doneItem = UIBarButtonItem(image: UIImage(named: "close"), style: .done, target: nil, action: #selector(MyView.Close))
            
            navItem.rightBarButtonItem = doneItem;
            navBar.setItems([navItem], animated: false);
            view.addSubview(navBar)
            return view
        }))
        header.height = { 50 }
        section.header = header

        return section
        
        
        
    }
    
}


