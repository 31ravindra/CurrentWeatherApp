//
//  CoreDataModel.swift
//  WeatherApp
//
//  Created by Ravindra Patidar on 11/07/21.
//

import Foundation

struct CoreDataModel {
    var city: String?
    var desc: String?
    var icon: Data?
    var mintemp: Double?
    var maxtemp: Double?
    var temp: Double?
    var humidity: Double?
    var lastUpdated = Date()
    var isFav: Bool = false
    
    init(city: String?, desc: String?, icon: Data?, minTemp: Double?, maxTemp: Double?, temp: Double?, humidity: Double?, isFav: Bool) {
        self.city = city
        self.desc = desc
        self.icon = icon
        self.mintemp = minTemp
        self.maxtemp = maxTemp
        self.temp = temp
        self.humidity = humidity
        self.isFav = isFav
    }
}
