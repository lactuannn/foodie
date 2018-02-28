//
//  AddFoodVC.swift
//  Food
//
//  Created by Lac Tuan on 2/7/18.
//  Copyright © 2018 Lac Tuan. All rights reserved.
//

import UIKit
import RealmSwift

protocol AddFoodVCDelegate: NSObjectProtocol{
    
    func reloadData()
}

class AddFoodVC: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tit: UILabel!
    
    //MARK: - Variables
    
    weak var delegate: AddFoodVCDelegate?
    
    var addFoodView: AddFoodView!
    private var imgData: Data!
    
    private let imagePicker = UIImagePickerController()
    private var realm = try! Realm()
    
    var isAddFood: Bool!
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imgPlaceholder = #imageLiteral(resourceName: "placeholder-square")
        imgData = UIImageJPEGRepresentation(imgPlaceholder, 0.3)
        imagePicker.delegate = self
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(hiddenKeyboard))
        view.addGestureRecognizer(tapGes)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if addFoodView == nil{
            
            addFoodView = AddFoodView.creatView()
            addFoodView.delegate = self
            scrollView.contentSize = addFoodView.frame.size
            scrollView.addSubview(addFoodView)
        }
        
        if isAddFood {
            addFoodView.addressLbl.text = "Giá: "
            addFoodView.nameLbl.text = "Tên món: "
            tit.text = "THÊM MÓN ĂN"
        } else {
            addFoodView.addressLbl.text = "Địa chỉ: "
            addFoodView.nameLbl.text = "Tên quán: "
            tit.text = "THÊM QUÁN ĂN"
        }
    }
    
    //MARK: - IBActions

    @IBAction func backBtn(_ sender: UIButton){
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func doneBtnPressed(_ sender: UIButton){
        
        var value = [String:Any]()
        
        if addFoodView.nameTextField.text != "", addFoodView.addressTextField.text != "" {
            
            if let img = imgData{
                value["thumb"] = img
            }
            
            if let name = addFoodView.nameTextField.text {
                value["name"] = name
            }
            
            if isAddFood {
                if let price = addFoodView.addressTextField.text {
                    value["price"] = price
                }
            } else {
                if let address = addFoodView.addressTextField.text {
                    value["address"] = address
                }
            }
            
            try! realm.write {
                
                if isAddFood {
                    realm.add(ListFood(value: value))
                } else {
                    realm.add(Location(value: value))
                }
            }
            
            delegate?.reloadData()
            navigationController?.popViewController(animated: true)
        } else {
            let alert = UIAlertController(title: "Nhập tên món ăn, giá", message: "", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }
        
    }
    
    @objc func keyboardWillShow(notification: Notification){
        
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                self.scrollView.contentInset.bottom = 0.0
            } else {
                //self.scrollView.contentInset.bottom = endFrame?.size.height
                self.scrollView.contentInset.bottom = 200
            }
        }
    }
    
    @objc func hiddenKeyboard(){
        
        self.scrollView.contentInset.bottom = 0
        self.view.endEditing(true)
        
    }

}

//MARK: - AddFoodView Delegate

extension AddFoodVC: AddFoodViewDelegate {
    
    func presentImagePicker() {
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
}

//MARK: - ImagePicker Delegate

extension AddFoodVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            
            imgData = UIImageJPEGRepresentation(image, 0.3)
            addFoodView.thumb.image = image
            picker.dismiss(animated: true, completion: nil)
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
    }
}
