//
//  NearFood.swift
//  Food
//
//  Created by Lac Tuan on 3/2/18.
//  Copyright © 2018 Lac Tuan. All rights reserved.
//

import Foundation
import ObjectMapper

class NearFood: Mappable {
    
    var id = ""
    var name = ""
    var open_now: Bool!
    var vicinity = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id <- map["id"]
        name   <- map["name"]
        open_now         <- map["open_now"]
        vicinity      <- map["vicinity"]
        
    }

}

class ResponseNearFood: Mappable {
    
    var status:String?
    var results:[NearFood]?
    var next_page_token:String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        status <- map["status"]
        next_page_token <- map["next_page_token"]
        results <- map["results"]
        
    }
    
}
