//
//  Constant.swift
//  WeatherApp
//
//  Created by Ravindra Patidar on 11/07/21.
//

import Foundation

struct AppUrl {
    
    private struct Domain {
        static let WeatherURL = "https://api.openweathermap.org"
    }
    
    private struct Route {
        static let Api = "/data/2.5/weather"
        static let iconUrl = "/img/w/"
    }
    
    //private static var baseURL = ""
    static let baseURL = Domain.WeatherURL + Route.Api
    
    static let weatherIconUrl = Domain.WeatherURL + Route.iconUrl
    
    static let apiKey = "cfacb12c5c0471815eecedd3de2ed308"
}
