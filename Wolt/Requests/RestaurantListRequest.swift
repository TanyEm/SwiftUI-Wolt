//
//  RestaurantListRequest.swift
//  Wolt
//
//  Created by Tatiana Podlesnykh on 3.1.2021.
//

import Foundation

struct RestaurantListRequest {
    
    func getStationList(lat: Double, lon: Double, callback: @escaping (_ result: [RestaurantResponseData])->()) {
        
        var components = URLComponents()
            components.scheme = "https"
            components.host = "restaurant-api.wolt.fi"
            components.path = "/v3/venues"
            components.queryItems = [
                URLQueryItem(name: "lat", value: "\(lat)"),
                URLQueryItem(name: "lon", value: "\(lon)")
            ]

        guard let restaurantDataURL = components.url else { return }
        
        var request = URLRequest(url: restaurantDataURL)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print("error=\(String(describing:error))")
                return
            }

            do {
                let response = try JSONDecoder().decode(RestaurantRequestModel.self, from: data!)
                    callback(response.results as! [RestaurantResponseData])
                } catch {
                    print(error)
                }
            }
        task.resume()
    }
}