//
//  ViewController.swift
//  Charts Practices
//
//  Created by 李森 on 2017/10/11.
//  Copyright © 2017年 李森. All rights reserved.
//

import UIKit
import Charts
import SnapKit

class ViewController: UIViewController {
    
    fileprivate var chartView: LineChartView = LineChartView(frame: CGRect.zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        view.addSubview(chartView)
        chartView.snp.makeConstraints { (make) in
            make.center.equalTo(view)
            make.width.equalTo(view)
            make.height.equalTo(300.0)
        }
        configureChartView()
    }
    
    fileprivate func configureChartView() {
        var datas: [ChartDataEntry] = [ChartDataEntry]()
        
        for i in 0...10 {
            let entry: ChartDataEntry = ChartDataEntry(x: Double(i)*10, y: Double(i)*13)
            datas.append(entry)
        }
        let dataSet: LineChartDataSet = LineChartDataSet(values: datas, label: "label")
        let chartData: LineChartData = LineChartData(dataSet: dataSet)
        chartView.data = chartData
    }
}
