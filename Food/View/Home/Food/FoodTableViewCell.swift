//
//  HomeTableViewCell.swift
//  Food
//
//  Created by Lac Tuan on 2/12/18.
//  Copyright © 2018 Lac Tuan. All rights reserved.
//

import UIKit
import RealmSwift

private let foodCellId = "foodCell"

protocol FoodCellDelegate: NSObjectProtocol{
    
    func showAlert(_ alert: UIAlertController)
}

class FoodTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var noticeLbl: UILabel!
    
    weak var delegate: FoodCellDelegate?
    
    private var data = [ListFood]()
    
    private var notificationToken: NotificationToken?
    
    private var realm = try! Realm()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.registerNib(FoodCollectionViewCell.self, foodCellId)
        
        realm.autorefresh = false
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressed))
        
        self.collectionView.addGestureRecognizer(longPress)
    }
    
    @objc func longPressed(longPressGestureRecognizer: UILongPressGestureRecognizer){
        
        if longPressGestureRecognizer.state == UIGestureRecognizerState.began {
            let touchPoint = longPressGestureRecognizer.location(in: self.collectionView)
            
            if let indexPath = collectionView.indexPathForItem(at: touchPoint){
                
                handleDeleteItem(indexPath[1])
            }
        }
    }
    
    func handleDeleteItem(_ index: Int){
        
        let alert = UIAlertController(title: "Có chắc muốn xoá?", message: nil, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Không", style: .cancel, handler: nil)
        let ok = UIAlertAction(title: "Xoá", style: .default) {[weak self] (_) in
            
            guard let strongSelf = self else { return }
            
            try! strongSelf.realm.write {
                strongSelf.realm.delete(strongSelf.data[index])
               // strongSelf.realm.refresh()
                strongSelf.data.remove(at: index)
            }
            
            strongSelf.collectionView.reloadData()
        }
        
        alert.addAction(cancel)
        alert.addAction(ok)
        
        delegate?.showAlert(alert)
    }
    
    func configure(_ data: Any,_ string: String){
        
        title.text = string
        
        if let item = data as? [ListFood] {
            self.data = item
            collectionView.reloadData()
        }
    }
}

extension FoodTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = data[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: foodCellId, for: indexPath) as! FoodCollectionViewCell
        
        cell.configure(item)
        
        
        return cell
    }
}

extension FoodTableViewCell: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 220, height: 140)
    }
}





