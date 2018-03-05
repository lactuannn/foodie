//
//  RandomFoodVC.swift
//  Food
//
//  Created by Lac Tuan on 2/7/18.
//  Copyright © 2018 Lac Tuan. All rights reserved.
//

import UIKit
import RealmSwift
import BubbleTransition
import FirebaseDatabase
import FirebaseFirestore
import PKHUD
import FirebaseAuth

private let kVoteCellId = "voteCell"

class RandomFoodVC: UIViewController {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var randomBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Variables
    
    private var realm = try! Realm()
    
    private var data = [VoteFood]()
    private var vote = [Int]()
    
    private  let transition = BubbleTransition()
    
    private var notificationToken: NotificationToken?
    
    private var name: String!
    
    private var db: Firestore!
    
    private var ref: DatabaseReference!
    
    var isVoted: Bool!
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        
        fetchUser()
        
        db = Firestore.firestore()
        
        fetchVoteFromDatabase {
            self.configureTable()
        }
        
        
    }
    
    func fetchUser(){
        
        let uid = Auth.auth().currentUser?.uid
        
        ref = Database.database().reference(withPath: "User").child(uid!)
        
        ref.observe(DataEventType.value) { (snapshot) in
            
            for vote in snapshot.children.allObjects as! [DataSnapshot] {
                
                if let object = vote.value as? Bool {
                    self.isVoted = object
                }
            }
        }
    }
    
    func configureTable(){
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        
        tableView.registerNib(VoteTableViewCell.self, kVoteCellId)
        
        tableView.separatorStyle = .none
        tableView.reloadData()
    }
    
    //    func setUpRealm(){
    //
    //        func updateList() {
    //
    //            let list = Array(realm.objects(ListFood.self))
    //            data = list
    //        }
    //        updateList()
    //
    //        // Notify us when Realm changes
    //        self.notificationToken = self.realm.observe { _,_ in
    //            updateList()
    //        }
    //    }
    //
    //    deinit {
    //
    //        notificationToken?.invalidate()
    //    }
    
    //MARK: - IBAction
    
    //    @IBAction func randomBtnPressed(_ sender: UIButton){
    //
    //        if data.count > 0 {
    //            let number = Int(arc4random_uniform(UInt32(data.count)))
    //            Global.shared.addHistory(dict: ["title": data[number].name,
    //                                            "thumb": data[number].thumb ?? nil,
    //                                                    "price": data[number].price])
    //            performSegue(withIdentifier: "sgRandom", sender: number)
    //        } else {
    //            print("Empty")
    //        }
    //    }
    
    //    func getListFood(completion: (() -> ())?){
    //
    //        db.collection("ListFood").document("Food").getDocument {[weak self] (snapshot, error) in
    //
    //            guard let strongSelf = self else { return }
    //
    //
    //            if error != nil {
    //                print("error:", error?.localizedDescription ?? "")
    //                return
    //            }
    //
    //            guard let snapshot = snapshot?.data()!["Food"] as? [[String: Any]] else { return }
    //
    //            for snap in snapshot {
    //
    //                if let name = snap["name"] as? String{
    //
    //                }
    //            }
    //            completion?()
    //        }
    //    }
    
    func fetchVoteFromDatabase(completion: (() -> ())?){
        
        let ref = Database.database().reference().child("Food")
        
        ref.observe(DataEventType.value, with: { [weak self] (snapshot) in
            
            guard let strongSelf = self else { return }

            if snapshot.childrenCount > 0 {
                
                strongSelf.data.removeAll()
                
                for food in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    let object = food.value as? [String: Any]
                    
                    if let name = object?["name"] as? String,
                        let key = object?["key"] as? String,
                        let vote = object?["vote"] as? Int{
                        
                        strongSelf.data.append(VoteFood.init(name, vote, key))
                    }
                }
                strongSelf.tableView.reloadData()
                completion?()
            }
            
        })
    }
    
    //MARK: - Prepare Segue
    
}

//MARK: - TableView DataSource

extension RandomFoodVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: kVoteCellId, for: indexPath) as! VoteTableViewCell
        
        cell.delegate = self
        
        cell.configure(data[indexPath.row], isVoted)
        
        return cell
    }
}

//MARK: - TableView Delegate

extension RandomFoodVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 70
    }
}

// MARK: UIViewControllerTransitioningDelegate

extension RandomFoodVC: UIViewControllerTransitioningDelegate{
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = randomBtn.center
        transition.bubbleColor = self.view.backgroundColor!
        transition.duration = 0.5
        return transition
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = randomBtn.center
        transition.bubbleColor = UIColor.white
        return transition
    }
}


extension RandomFoodVC: VoteCellDelegate {
    
    func presentAlert(_ alert: UIAlertController) {
        
        present(alert, animated: true, completion: nil)
    }
}








