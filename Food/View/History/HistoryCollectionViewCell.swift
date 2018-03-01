//
//  HistoryCollectionViewCell.swift
//  Food
//
//  Created by Lac Tuan on 2/8/18.
//  Copyright © 2018 Lac Tuan. All rights reserved.
//

import UIKit

protocol HistoryCollectionViewCellDelegate: NSObjectProtocol{
    func deleteItem(_ btnTag: Int)
}

class HistoryCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var thumb: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    
    var btnTag: Int!
    
    weak var delegate: HistoryCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize.zero
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 10
        self.thumb.layer.cornerRadius = 10
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
