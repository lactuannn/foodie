//
//  HomeCollectionViewCell.swift
//  Food
//
//  Created by Lac Tuan on 2/7/18.
//  Copyright © 2018 Lac Tuan. All rights reserved.
//

import UIKit

protocol HomeCollectionViewCellDelegate: NSObjectProtocol{
    
    func deleteItem(_ tag: Int)
}

class HomeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var thumb: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!

    var btnTag: Int!
    
    weak var delegate: HomeCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 0.4
        self.layer.shadowOffset = CGSize.zero
        self.layer.masksToBounds = false
  
    }
    
    @IBAction func deleteBtnPressed(_ sender: UIButton){
        
        delegate?.deleteItem(btnTag)     
    }
    
    func configure(_ title: String, _ img: Data,_ price: String) {
        
        name.text = title
        
        let image = UIImage(data: img)
        
        thumb.image = image
        
        self.price.text = "\(price)₫"
    }
    
}
