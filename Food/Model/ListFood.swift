//
//  Meals.swift
//  Food
//
//  Created by Lac Tuan on 2/7/18.
//  Copyright © 2018 Lac Tuan. All rights reserved.
//

import Foundation
import RealmSwift

class ListFood: Object {
    
    @objc dynamic var name = ""
    @objc dynamic var price = ""
    @objc dynamic var isLiked = false
    @objc dynamic var thumb: Data!
}
