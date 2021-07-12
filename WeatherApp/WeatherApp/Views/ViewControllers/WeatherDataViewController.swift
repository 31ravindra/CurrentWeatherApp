//
//  WeatherDataViewController.swift
//  WeatherApp
//
//  Created by Ravindra Patidar on 11/07/21.
//

import UIKit

class WeatherDataViewController: UIViewController {
    
    @IBOutlet weak var txtEnterCity: UITextField!
    
    @IBOutlet weak var btnSubmit: UIButton!
    
    @IBOutlet weak var viewDetails: UIView!
    
    @IBOutlet weak var imgWeather: UIImageView!
    
    @IBOutlet weak var lblDesc: UILabel!
    
    @IBOutlet weak var lblTemp: UILabel!
    
    @IBOutlet weak var lblMinTemp: UILabel!
    
    @IBOutlet weak var lblMaxTemp: UILabel!
    
    @IBOutlet weak var lblHumidity: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var weatherViewModel : WeatherViewModel!
    var coreDataModel: CoreDataManager!
    var imgData: Data?
    var isComeFromFav = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        checkNetwork()
        // Do any additional setup after loading the view.
    }
    
    func setUI() {
        viewDetails.isHidden = true
        activityIndicator.isHidden = true
        btnSubmit.layer.cornerRadius = 15.0
        txtEnterCity.layer.borderWidth = 1.0
        txtEnterCity.layer.borderColor = UIColor.darkGray.cgColor
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func checkNetwork() {
        let isConnected = checkInternet()
        if !isConnected {
            self.showToast(message: "No Internet Connection", font: UIFont.systemFont(ofSize: 15.0))
            viewDetails.isHidden = false
            let lastUpdatedWea = coreDataModel.getLastUpdatedData()
            txtEnterCity.text = lastUpdatedWea?.city
            lblDesc.text = lastUpdatedWea?.desc
            lblTemp.text = "\(lastUpdatedWea?.temp ?? 0.0) 'C"
            lblMinTemp.text = "\(lastUpdatedWea?.mintemp ?? 0.0) 'C"
            lblMaxTemp.text = "\(lastUpdatedWea?.maxtemp ?? 0.0) 'C"
            lblHumidity.text = "\(lastUpdatedWea?.humidity ?? 0.0)% "
            guard let imgData = lastUpdatedWea?.icon else {
                return
            }
            self.imgWeather.image = UIImage(data: imgData)
            
        }
    }
    
    
    @IBAction func btnSubmitClicked(_ sender: Any) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        let cityName = txtEnterCity.text ?? ""
        callToViewModelForUIUpdate(cityName: cityName)
    }
    
    @IBAction func AddFavCity(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle:nil)
        
        let favoriteCityViewController = storyBoard.instantiateViewController(withIdentifier: "FavoriteCityViewController") as! FavoriteCityViewController
        favoriteCityViewController.delegate = self
        self.navigationController?.pushViewController(favoriteCityViewController, animated: true)
        
    }
    
    func callToViewModelForUIUpdate(cityName: String) {
        self.weatherViewModel =  WeatherViewModel(cityName: cityName)
        self.weatherViewModel.bindWeatherViewModelToController = {[weak self] in
            DispatchQueue.main.async {
                self?.activityIndicator.isHidden = true
                self?.activityIndicator.stopAnimating()
                self?.viewDetails.isHidden = false
                self?.updateUI()
            }
            
        }
        self.weatherViewModel.errorClouser = {[weak self](error) in
            DispatchQueue.main.async {
                self?.showToast(message: error.msg, font: UIFont.systemFont(ofSize: 15.0))
            } 
        }
    }
    
    func updateUI() {
        guard let wData =  self.weatherViewModel.weatherData else {
            return
        }
        
        guard let imgIcon = wData.weather[0].icon else {
            return
        }
        DispatchQueue.global().async {
            self.weatherViewModel.getImageFromUrl(icon: imgIcon, completion: {[weak self](data) in
                DispatchQueue.main.async {
                    self?.imgData = data
                    self?.imgWeather.image = UIImage(data: data)
                    self?.saveData(weatherData: wData)
                }
            })
        }
        
        self.lblDesc.text = wData.weather[0].description
        self.lblTemp.text = "\(wData.main.temp ?? 0) 'C"
        self.lblMinTemp.text = "\(wData.main.tempMin ?? 0) 'C"
        self.lblMaxTemp.text = "\(wData.main.tempMax ?? 0) 'C"
        self.lblHumidity.text = "\(wData.main.humidity ?? 0) %"
        
    }
    
    
    func saveData(weatherData: CityWeatherResponse) {
        let city = txtEnterCity.text ?? ""
        let desc = weatherData.weather[0].description
        let minTemp = weatherData.main.tempMin
        let maxTemp = weatherData.main.tempMax
        let temp = weatherData.main.temp
        guard let humidity = weatherData.main.humidity else {
            return
        }
        var isFav = false
        if isComeFromFav {
            isFav = true
        }
        let coreDataH = CoreDataModel(city: city, desc: desc, icon: imgData, minTemp: minTemp, maxTemp: maxTemp, temp: temp, humidity: humidity, isFav: isFav)
        
        if coreDataModel.checkCityAlreadyInDataBase(cityName: city) {
            coreDataModel.updateData(cityName:city , updateValueTo: coreDataH, completion: {(isUpdated) in
                print(isUpdated)
            })
        } else {
            coreDataModel.save(weaData: coreDataH, useEntity: "Weather", completion: {(isSaved) in
                print(isSaved)
            })
        }
        
        
    }
}


extension WeatherDataViewController: SendSelectedCityName {
    func sendCityName(cityName: String) {
        txtEnterCity.text = cityName
        callToViewModelForUIUpdate(cityName: cityName)
    }
}
