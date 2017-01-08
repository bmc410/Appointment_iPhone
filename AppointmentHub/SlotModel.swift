//
//  SlotModel.swift
//  AppointmentHub
//
//  Created by William McCoy on 12/14/16.
//  Copyright © 2016 William McCoy. All rights reserved.
//

import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class SlotModel: Mappable {
    var StartSlot: String?
    var EndSlot: String?
    var dtStartSlot:Date?
    var dtEndSlot:Date?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        StartSlot <- map["StartSlot"]
        EndSlot <- map["EndSlot"]
    }
}
