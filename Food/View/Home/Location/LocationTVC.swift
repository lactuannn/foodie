//
//  LocationTVC.swift
//  Food
//
//  Created by Lac Tuan on 2/12/18.
//  Copyright © 2018 Lac Tuan. All rights reserved.
//

import UIKit

private let locationCellId = "locationCell"

class LocationTVC: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var title: UILabel!
    
    var data = [Location]()

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.registerNib(LocationCollectionViewCell.self, locationCellId)
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

