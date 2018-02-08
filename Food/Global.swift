//
//  Global.swift
//  Food
//
//  Created by Lac Tuan on 2/8/18.
//  Copyright © 2018 Lac Tuan. All rights reserved.
//

import Foundation


class Global {
    
    var pref: UserDefaults!
    
    static let shared : Global = {
        let instanceGl = Global()
        return instanceGl
    }()
    
    private init() {
        pref = UserDefaults.standard
    }
    
    func addFavoriteChannel(dict: [String: String]) {
        var history = [[String: String]]()
        if let _history = pref.object(forKey: "history") as? [[String: String]] {
            history = _history
        }
        history.append(dict)
        
        pref.set(history, forKey: "history")
    }
    
    func getFavoriteChannel() -> [[String: String]]! {
        guard let history = pref.object(forKey: "history") as? [[String: String]] else { return nil }
        return history
    }
    
    func deleteFavoriteChannel(index: Int) {
        guard var history = pref.object(forKey: "history") as? [[String: String]] else { return }
        history.remove(at: index)
        
        pref.set(history, forKey: "history")
    }

}
