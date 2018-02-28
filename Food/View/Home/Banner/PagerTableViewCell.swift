//
//  PagerTableViewCell.swift
//  Food
//
//  Created by Lac Tuan on 2/21/18.
//  Copyright © 2018 Lac Tuan. All rights reserved.
//

import UIKit
import FSPagerView
import Kingfisher
import FirebaseFirestore

class PagerTableViewCell: UITableViewCell, FSPagerViewDataSource, FSPagerViewDelegate {

    @IBOutlet weak var pagerView: FSPagerView!
    
    //private var item = [UIImage]()
    
    private var db: Firestore!
    
    private var item = [String]()

    override func awakeFromNib() {
        super.awakeFromNib()
        
        db = Firestore.firestore()
        getBannerThumb {
            self.setUpPager()
        }

    }
    
    func setUpPager(){
        pagerView.dataSource = self
        pagerView.delegate = self
        pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        
        pagerView.isInfinite = true
        pagerView.automaticSlidingInterval = 4.0
        pagerView.itemSize = CGSize(width: 300, height: 160)
        pagerView.transformer = FSPagerViewTransformer(type: .overlap)
    }
    
    func getBannerThumb(completion: (() -> ())?){
        
        db.collection("Banner").document("Banner").getDocument {[weak self] (snapshot, error) in
            
            guard let strongSelf = self else { return }
            
            
            if error != nil {
                print("error:", error?.localizedDescription ?? "")
                return
            }
            
            guard let snapshot = snapshot?.data()!["thumb"] as? [String] else { return }
            
            for snap in snapshot {
                
                strongSelf.item.append(snap)
            }
            completion?()
        }
    }
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return item.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        
        let url = URL(string: item[index])
        
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.layer.masksToBounds = true
        cell.imageView?.kf.setImage(with: url!, options:[.transition(ImageTransition.fade(0.5))])
        
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        
        //delegate?.toDetail(videos[index])
    }
    
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        
    }
    
}
