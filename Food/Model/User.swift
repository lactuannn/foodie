//
//  User.swift
//  Food
//
//  Created by Lac Tuan on 3/5/18.
//  Copyright © 2018 Lac Tuan. All rights reserved.
//

import Foundation

class User {
    
    var name: String!
    var isVoted: Bool!
    
    init(_ name: String,_ isVoted: Bool) {
        
        self.name = name
        self.isVoted = isVoted
    }
}
