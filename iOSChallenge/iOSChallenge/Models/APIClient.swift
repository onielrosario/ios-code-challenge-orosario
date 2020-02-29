//
//  APIClient.swift
//  iOSChallenge
//
//  Created by Oniel Rosario on 2/28/20.
//  Copyright © 2020 Oniel Rosario. All rights reserved.
//

import UIKit

enum EndpointModifiers: String {
    case onielChallenge = "ios-code-challenge-orosario"
    // can add more cases to modify enpoint
}


final class APIClient {
    static func getData(endpointModifier: String, page: Int, completionHandler: @escaping([HygeneChartData]?,Error?, Int?, Int?) -> Void ) {
        let endpoint = "https://raw.githubusercontent.com/rune-labs/\(endpointModifier)/master/api/\(page).json"
        guard let url = URL(string: endpoint) else {
            completionHandler(nil,nil,nil, nil)
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completionHandler(nil, error, nil, nil)
            }
            if let response = response as? HTTPURLResponse {
                completionHandler(nil,nil,nil, response.statusCode)
            }
            if let data = data {
                let chartData = try? JSONDecoder().decode([HygeneChartData].self, from: data)
                completionHandler(chartData, nil, page, nil)
            }
        }.resume()
    }
}
