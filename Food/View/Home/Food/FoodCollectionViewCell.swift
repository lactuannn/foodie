//
//  HomeCollectionViewCell.swift
//  Food
//
//  Created by Lac Tuan on 2/7/18.
//  Copyright © 2018 Lac Tuan. All rights reserved.
//

import UIKit
import RealmSwift
import Kingfisher

protocol HomeCollectionViewCellDelegate: NSObjectProtocol{
    
    func deleteItem(_ tag: Int)
    func isLike(_ bool: Bool,_ tag: Int)
}

class FoodCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var thumb: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var likeBtn: UIButton!

    var btnTag: Int!
    var isLiked = false
    
    weak var delegate: HomeCollectionViewCellDelegate?
    
    private var realm = try! Realm()
    private var notificationToken: NotificationToken?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize.zero
        self.layer.masksToBounds = false
    }
    
//    @IBAction func deleteBtnPressed(_ sender: UIButton){
//
//        delegate?.deleteItem(btnTag)
//    }
    
//    @IBAction func likeBtnPressed(_ sender: UIButton){
//
//        if isLiked {
//            likeBtn.setImage(#imageLiteral(resourceName: "ic_favorite_border"), for: .normal)
//            isLiked = false
//        } else {
//            likeBtn.setImage(#imageLiteral(resourceName: "ic_favorites"), for: .normal)
//            isLiked = true
//        }
//        delegate?.isLike(isLiked, btnTag)
//    }
//
    func configure(_ item: Any) {
        
        if let item = item as? ListFood{
            
            name.text = item.name
            
            self.price.text = "\(item.price)₫"
            
            if let data = item.thumb {
                
                let image = UIImage(data: data)
                
                thumb.image = image
                
            } else {
                
                let thumbUrl = item.thumbUrl
                    
                let url = URL(string: thumbUrl)
                    
                thumb.kf.setImage(with: url, options:[.transition(ImageTransition.fade(0.5))])
                
            }
        }
        
//        if isLiked{
//            likeBtn.setImage(#imageLiteral(resourceName: "ic_favorites"), for: .normal)
//        } else{
//            likeBtn.setImage(#imageLiteral(resourceName: "ic_favorite_border"), for: .normal)
//        }
    }
    
}
