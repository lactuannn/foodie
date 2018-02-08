//
//  AddFoodView.swift
//  Food
//
//  Created by Lac Tuan on 2/7/18.
//  Copyright © 2018 Lac Tuan. All rights reserved.
//

import UIKit

protocol AddFoodViewDelegate: NSObjectProtocol{
    
    func presentImagePicker()
}

class AddFoodView: UIView {
    
    @IBOutlet weak var thumb: UIImageView!
    @IBOutlet weak var changeImgBtn: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    
    //MARK: - Variables
    
    weak var delegate: AddFoodViewDelegate?
    
    //MARK: - Initialized

    class func creatView()->AddFoodView{
        
        let views = Bundle.main.loadNibNamed("AddFoodView", owner: self, options: nil)
        let view = views?.first as! AddFoodView
        
        let width = UIScreen.main.bounds.width
        view.frame = CGRect(x: 0, y: 0, width: width, height: UIScreen.main.bounds.height)
        
        view.configureView()
        return view
        
    }
    
    //MARK: - Configure View
    
    private func configureView(){
        
        nameTextField.delegate = self
        
        //Circle thumb
        
        thumb.layer.cornerRadius = thumb.frame.size.height / 2
        
        //Button
        
        changeImgBtn.layer.borderWidth = 1
        changeImgBtn.layer.borderColor = UIColor.lightGray.cgColor
        changeImgBtn.layer.cornerRadius = 20
        
    }
    
    @IBAction func changeImgPressed(_ sender: UIButton){
        
        delegate?.presentImagePicker()
    }

}

//MARK: - TextField Delegate

extension AddFoodView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}
