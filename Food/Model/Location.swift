//
//  Location.swift
//  Food
//
//  Created by Lac Tuan on 2/12/18.
//  Copyright © 2018 Lac Tuan. All rights reserved.
//

import Foundation
import RealmSwift

class Location: Object {
    
    @objc dynamic var name = ""
    @objc dynamic var address = ""
    @objc dynamic var thumb: Data? = nil
}
