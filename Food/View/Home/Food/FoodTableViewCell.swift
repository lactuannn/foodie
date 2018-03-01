//
//  HomeTableViewCell.swift
//  Food
//
//  Created by Lac Tuan on 2/12/18.
//  Copyright © 2018 Lac Tuan. All rights reserved.
//

import UIKit

private let foodCellId = "foodCell"


class FoodTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var noticeLbl: UILabel!
    
    var data = [ListFood]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.registerNib(FoodCollectionViewCell.self, foodCellId)
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





