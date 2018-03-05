//
//  VoteFood.swift
//  Food
//
//  Created by Lac Tuan on 3/5/18.
//  Copyright © 2018 Lac Tuan. All rights reserved.
//

import Foundation


class VoteFood {
    
    var name: String!
    var vote: Int!
    var key: String!
    
    init(_ name: String,_ vote: Int, _ key: String) {
        
        self.key = key
        self.name = name
        self.vote = vote
    }
}
