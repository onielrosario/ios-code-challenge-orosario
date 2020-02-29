//
//  APIClient.swift
//  iOSChallenge
//
//  Created by Oniel Rosario on 2/28/20.
//  Copyright © 2020 Oniel Rosario. All rights reserved.
//

import Foundation

enum EndpointModifiers: String {
    case onielChallenge = "ios-code-challenge-orosario"
    // can add more cases to modify enpoint
}


final class APIClient {
    static func getData(endpointModifier: String, page: Int = 1, completionHandler: @escaping([HygeneChartData]?,Error?) -> Void ) {
        let endpoint = "https://raw.githubusercontent.com/rune-labs/\(endpointModifier)/master/api/\(page).json"
        guard let url = URL(string: endpoint) else { return }
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                completionHandler(nil, error)
            } else if let data = data {
                let chartData = try? JSONDecoder().decode([HygeneChartData].self, from: data)
                completionHandler(chartData, nil)
            }
        }.resume()
    }
}
