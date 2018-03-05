//
//  VoteTableViewCell.swift
//  Food
//
//  Created by Lac Tuan on 3/4/18.
//  Copyright © 2018 Lac Tuan. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

protocol VoteCellDelegate: NSObjectProtocol{
    
    func presentAlert(_ alert: UIAlertController)
}

class VoteTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var vote: UILabel!
    
    weak var delegate: VoteCellDelegate?
    
    private var ref: DatabaseReference!
    
    private var refUser: DatabaseReference!
    
    private var uid: String!
    
    //private var key: String!
    
    private var isVoted = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        ref = Database.database().reference().child("Food")
        
        uid = Auth.auth().currentUser?.uid
        
        refUser = Database.database().reference().child("User").child(uid!)
    }
    
    func configure(_ item: Any, _ isVoted: Bool){

        if let item = item as? VoteFood{
            
            self.name.text = item.name
            self.vote.text = "\(item.vote!)"
            //self.key = item.key
        }
        
        self.isVoted = isVoted
    }
    
    @IBAction func thumbUp(_ sender: UIButton) {
        
        let key = ref.childByAutoId().key
        
        if isVoted {
            
            let alert = UIAlertController(title: nil, message: "Vừa vote rồi", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alert.addAction(ok)
            
            delegate?.presentAlert(alert)
            
        } else {
            let abc = Int(vote.text!)! + 1
            
            let food = ["vote": abc,
                        "key": key,
                        "name": name.text!] as [String : Any]
            
            ref.child(name.text!).setValue(food)
            
            vote.text = "\(abc)"
            
            let value = ["uid": uid,
                         "isVoted": true] as [String : Any]
            
            refUser.setValue(value)
        }
    }
}
