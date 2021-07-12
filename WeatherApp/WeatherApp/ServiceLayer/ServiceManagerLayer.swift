//
//  ServiceManagerLayer.swift
//  WeatherApp
//
//  Created by Ravindra Patidar on 10/07/21.
//

import Foundation

public struct MyError: Error {
    let msg: String
    
}

extension MyError: LocalizedError {
    public var errorDescription: String? {
        return NSLocalizedString(msg, comment: "")
    }
}

class ServiceManagerLayer  {
    
    func sendRequest(_ url: String, parameters: [String: String], completion: @escaping (CityWeatherResponse?, MyError?) -> Void) {
        var components = URLComponents(string: url)!
        components.queryItems = parameters.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        let request = URLRequest(url: components.url!)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard
                let data = data,                              // is there data
                let response = response as? HTTPURLResponse,  // is there HTTP response
                200 ..< 300 ~= response.statusCode,           // is statusCode 2XX
                error == nil                                  // was there no error
            else {
                completion(nil, MyError(msg: "No City Found"))
                return
            }
            let jsonDecoder = JSONDecoder()
            
            guard let weathData = try? jsonDecoder.decode(CityWeatherResponse.self, from: data) else {
                return }
            
            completion(weathData, nil)
        }
        task.resume()
    }
    
    
    func getDataFromImgUrl(url: String, completion: @escaping (Data) -> Void) {
        
        guard let urlImg = URL(string:url) else { return }
        let dataTask = URLSession.shared.dataTask(with: urlImg) {  (data, _, _) in
            if let data = data {
                completion(data)
            }
        }
        // Start Data Task
        dataTask.resume()
    }
}
