//
//  ViewController.swift
//  iOSChallenge
//
//  Created by Oniel Rosario on 2/28/20.
//  Copyright © 2020 Oniel Rosario. All rights reserved.
//

import UIKit
import Charts

class ViewController: UIViewController {
    @IBOutlet weak var chartView: LineChartView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    fileprivate func setupUI() {
        chartView.gridBackgroundColor = .white
        APIClient.getData(endpointModifier: EndpointModifiers.onielChallenge.rawValue) { (chartData, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let chartData = chartData {
                DispatchQueue.main.async {
                    self.chartView.data = self.modifyChartView(chartData)
                }
            }
        }
        
    }
    fileprivate func modifyChartView(_ data: [HygeneChartData]) -> LineChartData {
        let values = data.map { (chartData) -> ChartDataEntry in
            let date = Date(timeIntervalSince1970: Double(chartData.t))
            let formatter = DateFormatter()
            formatter.dateFormat = "dd"
            let displayDate = formatter.string(from: date)
            return ChartDataEntry(x: Double(displayDate)!, y: Double(chartData.y))
        }
        let set1 = LineChartDataSet(entries: values, label: "DataSet 1")
        return LineChartData(dataSet: set1)
    }
    
}
