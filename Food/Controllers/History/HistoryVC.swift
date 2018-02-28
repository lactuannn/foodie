//
//  HistoryVC.swift
//  Food
//
//  Created by Lac Tuan on 2/8/18.
//  Copyright © 2018 Lac Tuan. All rights reserved.
//

import UIKit

private let historyCellId = "historyCell"

class HistoryVC: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lbl: UILabel!
    
    //MARK: - Variables
    
    var data = [[String: Any]]()
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundView = lbl
        
        collectionView.registerNib(HistoryCollectionViewCell.self, historyCellId)
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let history = Global.shared.getHistory() else {
            return
        }
        
        if data.count != history.count {
            data = history
            collectionView.reloadData()
        }
        
    }
}


//MARK: - CollectionView Datatsource

extension HistoryVC: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if data.count > 0 {
            collectionView.backgroundView?.isHidden = true
            return data.count
        } else {
            collectionView.backgroundView?.isHidden = false
            return data.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = data[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: historyCellId, for: indexPath) as! HistoryCollectionViewCell
        
        cell.configure(item["title"] as! String, item["thumb"] as! Data, item["price"] as! String)
        
        return cell
    }
}

//MARK: - Collection Flowlayout DelegatE{

extension HistoryVC: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 328, height: 210)
    }
}














