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

class RandomFoodVC: UIViewController {
    
    @IBOutlet weak var randomBtn: UIButton!

    var realm = try! Realm()
    
    var data = [ListFood]()
    
    let transition = BubbleTransition()
    
    var notificationToken: NotificationToken?
    
    var name: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isHidden = true
        
        setUpRealm()
    }
    
    func setUpRealm(){
        
        func updateList() {
            
            let list = Array(realm.objects(ListFood.self))
            data = list
        }
        updateList()
        
        // Notify us when Realm changes
        self.notificationToken = self.realm.observe { _,_ in
            updateList()
        }
    }
    
    deinit {
        
        notificationToken?.invalidate()
    }

    @IBAction func randomBtnPressed(_ sender: UIButton){
        
        if data.count > 0 {
            let number = Int(arc4random_uniform(UInt32(data.count)))

            performSegue(withIdentifier: "sgRandom", sender: number)
        } else {
            print("Empty")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? DetailRandomVC, let index = sender as? Int {
            
            let img = UIImage(data: data[index].thumb)
            vc.transitioningDelegate = self
            vc.modalPresentationStyle = .custom
            vc.passName = data[index].title
            vc.image = img
        }
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









