//
//  ViewController.swift
//  Food
//
//  Created by Lac Tuan on 2/7/18.
//  Copyright © 2018 Lac Tuan. All rights reserved.
//

import UIKit
import RealmSwift

private let homeCellId = "homeCell"

class HomeVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lbl: UILabel!
    
    //MARK: - Variables
    
    var realm = try! Realm()
    
    var data = [ListFood]()
    var notificationToken: NotificationToken?
    
    var isEdit = false

    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpRealm()
      
        navigationController?.navigationBar.isHidden = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundView = lbl
        
        collectionView.registerNib(HomeCollectionViewCell.self, homeCellId)

    }
    
    @IBAction func addPressed(_ sender: UIButton){
        
        performSegue(withIdentifier: "sgAdd", sender: nil)
    }
    
    @IBAction func editPressed(_ sender: UIButton){
        
        if !isEdit {
            sender.setTitle("Done", for: .normal)
            isEdit = true
        } else {
            sender.setTitle("Edit", for: .normal)
            isEdit = false
        }
        collectionView.reloadData()
    }
    
    func setUpRealm(){
        
        func updateList() {
            
            let list = Array(realm.objects(ListFood.self))
            data = list
            collectionView.reloadData()
            
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

}

//MARK: - CollectionView Datsource

extension HomeVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if data.count > 0 {
            collectionView.backgroundView?.isHidden = true
            return data.count
        } else {
            collectionView.backgroundView?.isHidden = false
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = data[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: homeCellId, for: indexPath) as! HomeCollectionViewCell
        
        cell.btnTag = indexPath.row
        cell.delegate = self
        cell.configure(item.title, item.thumb, item.price)
        
        if isEdit {
            cell.deleteBtn.isHidden = false
        } else {
            cell.deleteBtn.isHidden = true
        }
        
        return cell
    }
}

//MARK: - TableView Delegate


extension HomeVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 328, height: 210)
    }
    
}


extension HomeVC: HomeCollectionViewCellDelegate{
    
    func deleteItem(_ tag: Int) {
        
        try! realm.write {
            realm.delete(data[tag])
        }
    }
}











