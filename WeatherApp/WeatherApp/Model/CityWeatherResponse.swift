//
//  CityWeatherResponse.swift
//  WeatherApp
//
//  Created by Ravindra Patidar on 10/07/21.
//

import Foundation

struct CityWeatherResponse: Codable {
    let main: Main
    let name: String?
    var weather:[WeatherData]
}

struct Main: Codable {
    let temp: Double?
    let feelsLike: Double?
    let tempMin: Double?
    let tempMax: Double?
    let pressure: Int?
    let humidity: Double?
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case humidity
    }
}

struct WeatherData: Codable {
    var id: Int?
    var main:String?
    var description: String?
    var icon: String?
}
