//
//  LocationTVC.swift
//  Food
//
//  Created by Lac Tuan on 2/12/18.
//  Copyright © 2018 Lac Tuan. All rights reserved.
//

import UIKit
import RealmSwift

private let locationCellId = "locationCell"

protocol LocationTVCDelegate: NSObjectProtocol{
    
    func presentAlert(_ alert: UIAlertController)
}

class LocationTVC: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var title: UILabel!
    
    var data = [Location]()

    weak var delegate: LocationTVCDelegate?
    
    private var realm = try! Realm()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.registerNib(LocationCollectionViewCell.self, locationCellId)
        
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
                strongSelf.data.remove(at: index)
            }
            
            strongSelf.collectionView.reloadData()
        }
        
        alert.addAction(cancel)
        alert.addAction(ok)
        
        delegate?.presentAlert(alert)
    }
    
    
    func configure(_ data: Any,_ string: String){
        
        title.text = string
        
        if let item = data as? [Location] {
            self.data = item
            collectionView.reloadData()
        }
    }
}


extension LocationTVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: locationCellId, for: indexPath) as! LocationCollectionViewCell
        
        cell.configure(data[indexPath.row])
        
        return cell
    }
}


extension LocationTVC: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 220, height: 140)
    }
}

