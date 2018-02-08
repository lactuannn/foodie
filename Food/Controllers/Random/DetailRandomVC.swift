//
//  DetailRandomVC.swift
//  Food
//
//  Created by Lac Tuan on 2/7/18.
//  Copyright © 2018 Lac Tuan. All rights reserved.
//

import UIKit

class DetailRandomVC: UIViewController {
    
    @IBOutlet weak var thumb: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    var passName: String!
    var image: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()

        name.text = passName
        thumb.image = image
    }

    @IBAction func cancel(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
}
