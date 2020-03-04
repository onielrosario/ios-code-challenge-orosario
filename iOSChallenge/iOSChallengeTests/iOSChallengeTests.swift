//
//  iOSChallengeTests.swift
//  iOSChallengeTests
//
//  Created by Oniel Rosario on 2/28/20.
//  Copyright © 2020 Oniel Rosario. All rights reserved.
//

import XCTest
@testable import iOSChallenge

class iOSChallengeTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testChartData() {
        let endpoint = "https://raw.githubusercontent.com/rune-labs/ios-code-challenge-orosario/master/api/1.json"
        let exp = expectation(description: "got data")
        guard let url = URL(string: endpoint) else { return }
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                XCTFail("could not get data: " + error.localizedDescription)
            } else if let data = data {
                if let chartData = try? JSONDecoder().decode([HygeneChartData].self, from: data) {
                    print(chartData.count)
                    exp.fulfill()
                }
            }
        }.resume()
        wait(for: [exp], timeout: 5.0)
    }
    
    func testCustomizePageSize() {
        var currentPage: Int = 1
        let size: Int = 11000
        var dataSet = [HygeneChartData]()
        APIClient.getData(endpointModifier: EndpointModifiers.onielChallenge.rawValue, page: currentPage) { (chartData, error, page, _) in
            if let error = error {
                print(error)
            } else if let chartData = chartData {
                if chartData.count == size {
                    dataSet = chartData
                    print(dataSet.count)
                } else if chartData.count < size {
                    dataSet.append(contentsOf: chartData)
                    currentPage += 1
                    self.testCustomizePageSize()
                }
            }
        }
    }
}
