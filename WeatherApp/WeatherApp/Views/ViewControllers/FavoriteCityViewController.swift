//
//  FavoriteCityViewController.swift
//  WeatherApp
//
//  Created by Ravindra Patidar on 11/07/21.
//

import UIKit

protocol SendSelectedCityName {
    func sendCityName(cityName: String)
}

class FavoriteCityViewController: UIViewController {
    @IBOutlet weak var txtFavCity: UITextField!
    
    @IBOutlet weak var btnSave: UIButton!
    
    @IBOutlet weak var tblView: UITableView!
    
    @IBOutlet weak var lblEmpty: UILabel!
    
    var places = [String]()
    let defaults = UserDefaults.standard
    var delegate: SendSelectedCityName?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Favorite Places"
        setTableView()
        setTxtFieldLayer()
        reloadTable()
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    func setTxtFieldLayer() {
        txtFavCity.layer.borderWidth = 1.0
        txtFavCity.layer.borderColor = UIColor.darkGray.cgColor
        
    }
    func setTableView() {
        tblView.delegate = self
        tblView.dataSource = self
        tblView.separatorStyle = .none
        tblView.rowHeight = UITableView.automaticDimension
        tblView.estimatedRowHeight = 44.0
    }
    func reloadTable() {
        if let places = defaults.array(forKey: "placesArray") as? [String]  {
            self.places = places
            if places.count > 0 {
                tblView.reloadData()
                lblEmpty.isHidden = true
            } else {
                lblEmpty.isHidden = false
            }
        }
    }
    @IBAction func btnSaveClicked(_ sender: Any) {
        if let txt = txtFavCity.text {
            if txt != "" {
                saveFavCity(cityName: txt)
            }
        }
    }
    
    func saveFavCity(cityName: String) {
        places.append(cityName)
        updateUserDefaults()
        reloadTable()
    }
    
    func updateUserDefaults() {
        defaults.set(places, forKey: "placesArray")
        defaults.synchronize()
    }
    
    
}

extension FavoriteCityViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "PlaceTableViewCell", for: indexPath) as! PlaceTableViewCell
        cell.selectionStyle = .none
        cell.setLblPlaceName(text: self.places[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cityName = self.places[indexPath.row]
        delegate?.sendCityName(cityName: cityName)
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // remove the item from the data model
            // delete the table view row
            
            self.places.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            updateUserDefaults()
            
        }
    }
    
    
}
