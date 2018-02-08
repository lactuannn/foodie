//
//  TableView .swift
//  Food
//
//  Created by Lac Tuan on 2/7/18.
//  Copyright © 2018 Lac Tuan. All rights reserved.
//

//MARK: - Quick Register nib

import UIKit

extension UITableView{
    
    func registerNib(_ nibClass: AnyClass,_ identifier: String){
        let nib = UINib.init(nibName: String(describing: nibClass.self), bundle: nil)
        
        self.register(nib, forCellReuseIdentifier: identifier)
    }
}

//MARK: - Quick Register nib

extension UICollectionView {
    
    func registerNib(_ nibClass: AnyClass,_ identifier: String){
        let nib = UINib.init(nibName: String(describing: nibClass.self), bundle: nil)
        
        self.register(nib, forCellWithReuseIdentifier: identifier)
    }
}

