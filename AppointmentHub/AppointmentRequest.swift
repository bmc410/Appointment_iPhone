//
//  AppointmentRequest.swift
//  AppointmentHub
//
//  Created by William McCoy on 11/23/16.
//  Copyright © 2016 William McCoy. All rights reserved.
//

import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class Customer: Mappable {


    var CustId: Int?
    var FirstName: String?
    var LastName: String?
    var Email: String?
    var Phone: String?
    var LastModified: String?
    var IsRegistered: Bool?
    var UserName: String?
    var Password: String?
    var PIN: String?

    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        CustId <- map["CustId"]
        FirstName <- map["FirstName"]
        LastName <- map["LastName"]
        Email <- map["Email"]
        Phone <- map["Phone"]
        LastModified <- map["LastModified"]
        IsRegistered <- map["IsRegistered"]
        UserName <- map["UserName"]
        Password <- map["Password"]
        PIN <- map["PIN"]
    }

    
}

class AppointmentRequest{
    
    var CustId:Int?
    var FirstName: String?
    var LastName: String?
    var Email: String?
    var Phone: String?
    var StartDateTime: String?
    var EndDateTime: String?
    var AppointmentType: Int?
    var Comment: String?
    
}
