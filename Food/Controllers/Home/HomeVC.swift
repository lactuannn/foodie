//
//  ViewController.swift
//  Food
//
//  Created by Lac Tuan on 2/7/18.
//  Copyright © 2018 Lac Tuan. All rights reserved.
//

import UIKit
import RealmSwift
import FirebaseFirestore
import PKHUD
import CoreLocation
import AlamofireObjectMapper
import Alamofire

private let locationCellId = "locationTableCell"
private let foodTableCellId = "foodTableCell"
private let pagerCellId = "pagerCell"

class HomeVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Variables
    
    private var realm = try! Realm()
    
    private var data = [Any]()
    private var titles = [String]()
    private var notificationToken: NotificationToken?
    
    private var isEdit = false
    private var listFood = [ListFood]()
    private var location = [Location]()
    private var nearFood = [NearFood]()
    
    private var db: Firestore!
    
    private var isAddFood: Bool!
    
    private let locationManager = CLLocationManager()
    
    private var locationCoor = ""

    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        
        getListChannel {
            self.setUpRealm()
        }
        
        titles = ["Món ăn",
                  "Địa điểm"]
      
        navigationController?.navigationBar.isHidden = true
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.allowsSelection = false
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        tableView.registerNib(FoodTableViewCell.self, foodTableCellId)
        tableView.registerNib(LocationTVC.self, locationCellId)
        tableView.registerNib(PagerTableViewCell.self, pagerCellId)
        
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            
        }
    }
    
    //MARK: - IBActions
    
    @IBAction func addPressed(_ sender: UIButton){
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let addFood = UIAlertAction(title: "Thêm món", style: .default) { [weak self] (_) in
            
            guard let strongSelf = self else { return }
            
            strongSelf.isAddFood = true
            
            strongSelf.performSegue(withIdentifier: "sgAddFood", sender: nil)
            
        }
        
        let addLocation = UIAlertAction(title: "Thêm địa điểm", style: .default) {[weak self] (_) in
            
            guard let strongSelf = self else { return }
            
            strongSelf.isAddFood = false
            
            strongSelf.performSegue(withIdentifier: "sgAddFood", sender: nil)
        }
        
        let cancel = UIAlertAction(title: "Huỷ", style: .cancel, handler: nil)
        
        alert.addAction(cancel)
        alert.addAction(addFood)
        alert.addAction(addLocation)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func editPressed(_ sender: UIButton){
        
        if !isEdit {
            sender.setTitle("Done", for: .normal)
            isEdit = true
        } else {
            sender.setTitle("Edit", for: .normal)
            isEdit = false
        }
    }
    
    func requestAPI(){
        
        let url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?parameters"
        
        let params: Parameters = [
            "key": API_KEY,
            "location": locationCoor,
            "radius": 500,
            "type": "restaurant"
        ]
        
        Alamofire
            .request(url, method: .get, parameters: params)
            .responseObject {[weak self] (res: DataResponse<ResponseNearFood> ) in
                
                guard let strongSelf = self else { return }
                
                if let error = res.error {
                    print(error)
                }
                
                guard let response = res.result.value else {
                    print("no value")
                    return
                }
                
                if let foods = response.results {
                    
                    strongSelf.nearFood.append(contentsOf: foods)
//                    strongSelf.data.append(strongSelf.nearFood)
                    strongSelf.tableView.reloadData()
                    
                }
        }
    }
    
    func getListChannel(completion: (() -> ())?){
        
        HUD.show(.labeledProgress(title: "Loading...", subtitle: nil))
        
        db.collection("Location").document("near").getDocument {[weak self] (snapshot, error) in
            
            guard let strongSelf = self else { return }
            
            
            if error != nil {
                print("error:", error?.localizedDescription ?? "")
                return
            }
            
            guard let snapshot = snapshot?.data()!["nearLocation"] as? [[String: Any]] else { return }
            
            for snap in snapshot {
                
                if let name = snap["name"] as? String,
                    let address = snap["address"] as? String {
                    
                    let value = ["name": name, "address": address]
                    
                    let location = Location(value: value)
                    
                    strongSelf.location.append(location)
                    
                   // print(strongSelf.location)
                }
            }
            
            HUD.hide(animated: true)
            
            completion?()
        }
        
        

    }
    
    func setUpRealm(){
        
        func updateList() {
            
            let list = Array(realm.objects(ListFood.self))
            let location = Array(realm.objects(Location.self))

            self.location += location
            self.listFood += list
            data = [self.listFood, self.location]
            tableView.reloadData()
        }
        updateList()
        
        // Notify us when Realm changes
//        self.notificationToken = self.realm.observe { _,_ in
//            updateList()
//            self.realm.refresh()
//        }
    }
    
    
    //MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let vc = segue.destination as? AddFoodVC {
            
            vc.isAddFood = isAddFood
            vc.delegate = self
        }
    }

}

//MARK: - TableView Datsource

extension HomeVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return data.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 1 {
            let item = data[indexPath.row]
            
            if item is [ListFood] {
                let cell = tableView.dequeueReusableCell(withIdentifier: foodTableCellId, for: indexPath) as! FoodTableViewCell
                
                if listFood.count == 0{
                    cell.noticeLbl.isHidden = false
                }else{
                    cell.noticeLbl.isHidden = true
                }
                
                cell.delegate = self
                
                cell.configure(item, titles[indexPath.row])
                
                return cell
                
            } else if item is [Location] {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: locationCellId, for: indexPath) as! LocationTVC
                
                cell.delegate = self
                
                cell.configure(item, titles[indexPath.row])
                
                return cell
                
            }
        } else if indexPath.section == 2 {
            
                let cell = tableView.dequeueReusableCell(withIdentifier: locationCellId, for: indexPath) as! LocationTVC
                
                cell.delegate = self
                
                cell.configure(nearFood, "Gần tôi")
                
                return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: pagerCellId, for: indexPath) as! PagerTableViewCell
            
            return cell
            
        }
        return UITableViewCell()
    }

}

//MARK: - TableView Delegate


extension HomeVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}

//MARK: - CLLocation Delegate

extension HomeVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }

        locationCoor = "\(locValue.latitude),\(locValue.longitude)"
        
        locationManager.stopUpdatingLocation()
        
        requestAPI()
    }
}

extension HomeVC: AddFoodVCDelegate{
    
    func reloadData() {
        
        data.removeAll()
        tableView.reloadData()
        listFood.removeAll()
        location.removeAll()
        getListChannel {
            self.setUpRealm()
        }
        
    }
}

extension HomeVC: FoodCellDelegate {
    
    func showAlert(_ alert: UIAlertController) {
        
        present(alert, animated: true, completion: nil)
    }
}

extension HomeVC: LocationTVCDelegate {
    
    func presentAlert(_ alert: UIAlertController) {
        present(alert, animated: true, completion: nil)
    }
}

//
//extension HomeVC: HomeCollectionViewCellDelegate{
//
//    func deleteItem(_ tag: Int) {
//
//        try! realm.write {
//            realm.delete(data[tag])
//        }
//    }
//
//    func isLike(_ bool: Bool,_ tag: Int) {
//
//        try! realm.write {
//            data[tag].isLiked = bool
//        }
//    }
//}











