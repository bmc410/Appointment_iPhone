//
//  ApptType.swift
//  AppointmentHub
//
//  Created by William McCoy on 11/25/16.
//  Copyright © 2016 William McCoy. All rights reserved.
//

import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class ApptType: Mappable {
    var ApptDescription: String?
    var ApptType: String?
    var ApptLength: Int?
    var ApptPrice: Double?
    var ApptTypeID: Int?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        ApptDescription <- map["ApptDescription"]
        ApptType <- map["ApptType"]
        ApptLength <- map["ApptLength"]
        ApptPrice <- map["ApptPrice"]
        ApptTypeID <- map["ApptTypeID"]
       
    }
}
