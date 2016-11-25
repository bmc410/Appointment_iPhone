//
//  RestAPI.swift
//  AppointmentHub
//
//  Created by William McCoy on 11/23/16.
//  Copyright © 2016 William McCoy. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

open class ParameterObject{
    enum ParamType {
        case string
        case number
        case boolean
        case array
    }
    
    var paramName: String?
    var paramValue: AnyObject?
    var paramType: ParamType?
}


open class RestAPI{
    //This is an attempt to have a single GET and POST endpoint
    
    func PostAPI(_ apiCall: String, postData: AnyObject,completion: @escaping (JSON) ->
        ()) {
        
        var request = URLRequest(url: URL(string:apiCall)!)
        
        //let request = NSMutableURLRequest(url: URL(string:apiCall)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody  = try JSONSerialization.data(withJSONObject: postData , options:[])
            
            
        } catch {
            
        }
        
        
        Alamofire.request(request as URLRequestConvertible)
            .responseJSON {
                response in
                switch response.result {
                case .success(let data):
                    let jsonData = JSON(data)
                    completion(jsonData)
                case .failure:
                    break
                }
        }
    }
    
    func GetAPI(_ apiCall: String, completion: @escaping (JSON) -> ()) {
        Alamofire.request(apiCall)
            .validate()
            .responseJSON {
                response in
                switch response.result {
                case .success(let data):
                    let jsonData = JSON(data)
                    completion(jsonData)
                case .failure:
                    break
                }
        }
    }
}
