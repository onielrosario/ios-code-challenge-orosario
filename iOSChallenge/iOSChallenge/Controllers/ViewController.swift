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
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    fileprivate var currentPage = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    fileprivate func setupUI() {
        chartView.pinchZoomEnabled = true
        chartView.xAxis.labelTextColor = .white
        chartView.leftAxis.labelTextColor = .white
        chartView.rightAxis.labelTextColor = .white
        updateChartByPage(page: currentPage)
    }
    
    fileprivate func modifyChartView(_ data: [HygeneChartData], page: Int) -> LineChartData {
        let values = data.map { (chartData) -> ChartDataEntry in
            let unixFormatted = convertUnixToDate(unix: chartData.t)
            return ChartDataEntry(x: unixFormatted, y: chartData.y)
        }
        let set = LineChartDataSet(entries: values, label: "Number of people - Month \(page)")
        set.mode = .linear
        set.circleRadius = 0
        set.lineWidth = 2
        set.setColor(.white)
        return LineChartData(dataSet: set)
    }
    
    fileprivate func convertUnixToDate(unix: Double) -> Double {
        let date = Date(timeIntervalSince1970: unix)
        let formatter = DateFormatter()
        formatter.dateFormat = "w"
        guard let unixConverted = Double(formatter.string(from: date)) else { return 0}
        return unixConverted
    }
    
    fileprivate func updateChartByPage(page: Int) {
        showSpinner()
        APIClient.getData(endpointModifier: EndpointModifiers.onielChallenge.rawValue, page: page) { [weak self](data, error, page, status ) in
            if let error = error {
                print(error.localizedDescription)
                self?.removeSpinner()
            } else if let data = data {
                DispatchQueue.main.async {
                    self?.chartView.data = self?.modifyChartView(data, page: self?.currentPage ?? 0)
                    self?.removeSpinner()
                }
            } else if let status = status {
                print(status)
                self?.statusCodeHandler(status: status)
            }
        }
    }
    
    fileprivate func statusCodeHandler(status: Int) {
        switch status {
        case 404:
            DispatchQueue.main.async {
                self.removeSpinner()
                self.presentAlertWithAction(title: status.description, message: "No more data available")
                self.currentPage = self.currentPage < 1 ? 1 : self.currentPage - 1
            }
        default:
            break
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
