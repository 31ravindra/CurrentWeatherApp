//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Ravindra Patidar on 11/07/21.
//

import Foundation


class WeatherViewModel {
    private var apiService : ServiceManagerLayer!
    private(set) var weatherData : CityWeatherResponse! {
        didSet {
            self.bindWeatherViewModelToController()
        }
    }
    
    var bindWeatherViewModelToController : (() -> ()) = {}
    var errorClouser : ((_ error: Error) -> Void)?
    init(cityName: String) {
        self.apiService =  ServiceManagerLayer()
        callFuncToGetWeatherData(cityName: cityName)
    }
    
    func callFuncToGetWeatherData(cityName: String) {
        let url = AppUrl.baseURL
        let apiKey = AppUrl.apiKey
        
        var paramDict = [String: String]()
        
        paramDict["q"] = cityName
        paramDict["appid"] = apiKey
        paramDict["units"] = "metric"
        DispatchQueue.global().async {
            self.apiService.sendRequest(url, parameters: paramDict, completion: {[weak self] (weathData, error) in
                if error == nil {
                    self?.weatherData = weathData
                } else {
                    self?.errorClouser?(error!)
                }
            })
        }
    }
    
    func getImageFromUrl(icon: String,  completion: @escaping ((Data) -> Void)) {
        let imgUrl = AppUrl.weatherIconUrl + icon
        apiService.getDataFromImgUrl(url: imgUrl, completion: {(data)in
            completion(data)
        })
    }
}
