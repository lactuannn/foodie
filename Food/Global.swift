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
    
    //MARK: - History
    
    func addHistory(dict: [String: Any]) {
        var history = [[String: Any]]()
        if let _history = pref.object(forKey: "history") as? [[String: Any]] {
            history = _history
        }
        history.append(dict)
        
        pref.set(history, forKey: "history")
    }
    
    func getHistory() -> [[String: Any]]! {
        guard let history = pref.object(forKey: "history") as? [[String: Any]] else { return nil }
        return history
    }
    
    func deleteHistory(index: Int) {
        guard var history = pref.object(forKey: "history") as? [[String: Any]] else { return }
        history.remove(at: index)
        
        pref.set(history, forKey: "history")
    }

    
    //MARK: - Favorite
    
    func addFavorite(dict: [String: Any]) {
        var favorite = [[String: Any]]()
        if let _favorite = pref.object(forKey: "favorite") as? [[String: Any]] {
            favorite = _favorite
        }
        favorite.append(dict)
        
        pref.set(favorite, forKey: "history")
    }
    
    func getFavorite() -> [[String: Any]]! {
        guard let favorite = pref.object(forKey: "favorite") as? [[String: Any]] else { return nil }
        return favorite
    }
    
    func deleteFavorite(index: Int) {
        guard var favorite = pref.object(forKey: "favorite") as? [[String: Any]] else { return }
        favorite.remove(at: index)
        
        pref.set(favorite, forKey: "favorite")
    }
}
