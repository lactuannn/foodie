//
//  LocationCollectionViewCell.swift
//  Food
//
//  Created by Lac Tuan on 2/12/18.
//  Copyright © 2018 Lac Tuan. All rights reserved.
//

import UIKit

class LocationCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var thumb: UIImageView!
    @IBOutlet weak var address: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize.zero
        self.layer.masksToBounds = false
        
        
    }
    
    func configure(_ item: Any) {
        
        if let item = item as? NearFood {
            
            name.text = item.name
            address.text = item.vicinity
            
            //            if let data = item.thumb {
            //                let image = UIImage(data: data)
            //
            //                thumb.image = image
            //            }
        }
        
        if let item = item as? Location {
            
            name.text = item.name
            address.text = item.address
            
            if let data = item.thumb {
                let image = UIImage(data: data)
                
                thumb.image = image
            }
            
        }
    }
}








