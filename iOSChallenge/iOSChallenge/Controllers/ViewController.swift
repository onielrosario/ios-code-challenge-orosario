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
    fileprivate var currentPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    fileprivate func setupUI() {
        chartView.pinchZoomEnabled = true
        chartView.tintColor = .white
        updateChartByPage(page: currentPage)
    }
    
    fileprivate func modifyChartView(_ data: [HygeneChartData], page: Int) -> LineChartData {
        let values = data.map { (chartData) -> ChartDataEntry in
            let date = Date(timeIntervalSince1970: Double(chartData.t))
            let formatter = DateFormatter()
            formatter.dateFormat = "d"
            let displayDate = formatter.string(from: date)
            return ChartDataEntry(x: Double(displayDate)!, y: Double(chartData.y))
        }
        let set = LineChartDataSet(entries: values, label: "Number of people - Month \(page)")
        return LineChartData(dataSet: set)
    }
    
    fileprivate func updateChartByPage(page: Int) {
        showSpinner()
        APIClient.getData(endpointModifier: EndpointModifiers.onielChallenge.rawValue, page: page) { [weak self](data, error, page) in
            if let error = error {
                print(error)
            } else if let data = data {
                DispatchQueue.main.async {
                    self?.chartView.data = self?.modifyChartView(data, page: self?.currentPage ?? 0)
                    self?.removeSpinner()
                }
            }
        }
    }
    
    @IBAction func nextPage(_ sender: UIButton) {
        currentPage += 1
        updateChartByPage(page: currentPage)
    }
    
    
    
    @IBAction func previousPage(_ sender: UIButton) {
        currentPage -= 1
        updateChartByPage(page: currentPage)
    }
}
