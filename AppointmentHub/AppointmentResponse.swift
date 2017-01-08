//
//  AppointmentResponse.swift
//  AppointmentHub
//
//  Created by William McCoy on 12/12/16.
//  Copyright © 2016 William McCoy. All rights reserved.
//

import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class AppointmentResponse: Mappable {
    
    
    var ApptID: Int?
    var IsSussessful: Bool?
    var Message: String?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        ApptID <- map["ApptID"]
        IsSussessful <- map["IsSussessful"]
        Message <- map["Message"]
    }
    
}
