//
//  MonthDetailViewController.swift
//  Monthey
//
//  Created by 钟信 on 2016/12/14.
//  Copyright © 2016年 zhongxin. All rights reserved.
//

import UIKit
import Charts
import pop
class MonthDetailViewController: UIViewController , UITableViewDelegate, UITableViewDataSource, ChartViewDelegate{
    
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var accountsTableView: UITableView!
    var accounts:[String]!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        pieChartView.delegate = self
        accounts = ["建设银行","兴业银行","支付宝","蚂蚁","蚂蚁"]
        let moneyNumbers = [5000.0, 5000.0, 5000.0, 2000.0, 2000.0]
        setChart(dataPoints: accounts, values: moneyNumbers)
        
        //TableView初始化
        accountsTableView.separatorStyle = .none
        accountsTableView.contentInset.top = -150
        accountsTableView.contentInset.bottom = 10

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backItemDidTaped(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    //渐变

    
    //chart
    func setChart(dataPoints: [String], values: [Double]) {
        var dataEntries: [PieChartDataEntry] = []
        var colors: [NSUIColor] = []
        for i in 0..<dataPoints.count {
            let dataEntry = PieChartDataEntry(value: values[i], label: accounts[i])
            dataEntries.append(dataEntry)
            colors.append(UIColor.white)
        }
        let chartDataSet = PieChartDataSet(values: dataEntries, label: "")
        let chartData = PieChartData(dataSets: [chartDataSet])
        pieChartView.data = chartData
        
        //UI
        pieChartView.noDataText = ""
        pieChartView.chartDescription?.text = ""
        pieChartView.drawEntryLabelsEnabled = false
        chartDataSet.drawValuesEnabled = false
        pieChartView.rotationEnabled = false
        
        
        pieChartView.backgroundColor = .clear
        pieChartView.holeColor = .clear
        pieChartView.entryLabelColor = .white
        chartDataSet.colors = colors
        
        pieChartView.legend.enabled = false
        
        pieChartView.setExtraOffsets(left: 0, top: 10, right: 0, bottom: 0)
        chartDataSet.sliceSpace = 3
        pieChartView.holeRadiusPercent = 0.76
        pieChartView.transparentCircleRadiusPercent = 0.8
        pieChartView.transparentCircleColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.24)
        
        //highlight
        chartDataSet.selectionShift = 3
        
        //animation
        pieChartView.animate(xAxisDuration: 0.5, yAxisDuration: 0.5, easingOption: .easeOutSine)        
    }
    

    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
    }
    
    //table
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "accountCell", for: indexPath)
//        createGradientLayer()
        return cell
        
    }
}
