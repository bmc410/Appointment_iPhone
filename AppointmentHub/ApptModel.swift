//
//  ApptModel.swift
//  AppointmentHub
//
//  Created by William McCoy on 11/23/16.
//  Copyright © 2016 William McCoy. All rights reserved.
//

import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class Appt: Mappable {
    var StartTime: String?
    var EndTime: String?
    var CustId: Int?
    var FirstName: String?
    var LastName: String?
    var Email: String?
    var Phone: String?
    var StartTimeString: String?
    var EndTimeString: String?
    var ApptDate: Date?
    var Duration: Int?
    var ApptId: Int?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        StartTime <- map["StartTime"]
        EndTime <- map["EndTime"]
        CustId <- map["CustId"]
        FirstName <- map["FirstName"]
        LastName <- map["LastName"]
        Email <- map["Email"]
        Phone <- map["Phone"]
        StartTimeString <- map["StartTimeString"]
        EndTimeString <- map["EndTimeString"]
        Duration <- map["Duration"]
        ApptId <- map["ApptId"]
        
    }
}



