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
    //ui
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var accountsTableView: UITableView!
    
    @IBOutlet weak var editRecordBg: UIView!
    @IBOutlet weak var editRecordButton: UIButton!
    @IBOutlet weak var cardView: UIView!
    
    //layout
    @IBOutlet weak var editRecordBgBottom: NSLayoutConstraint!
    @IBOutlet weak var editRecordBgWidth: NSLayoutConstraint!
    @IBOutlet weak var editRecordBgHeight: NSLayoutConstraint!
    @IBOutlet weak var editRecordButtonBottom: NSLayoutConstraint!
    
    var buttonBottom:CGFloat!
    var buttonHeight:CGFloat!
    
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
        
        //editRecord初始化
        editRecordButton.layer.borderColor = UIColor.clear.cgColor
        editRecordBg.layer.cornerRadius = 26
        editRecordBg.layer.shadowColor = UIColor(colorLiteralRed: 1/255, green: 40/255, blue: 98/255, alpha: 39/100).cgColor
        editRecordBg.layer.shadowOffset = CGSize(width: 0, height: 2)
        editRecordBg.layer.shadowRadius = 5
        editRecordBg.layer.shadowOpacity = 0.8
        cardView.alpha = 0.01
        
        //layout
        buttonHeight = editRecordBgHeight.constant
        buttonBottom = editRecordBgBottom.constant
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        pieChartView.setExtraOffsets(left: 0, top: 0, right: 0, bottom: 0)
        chartDataSet.sliceSpace = 3
        pieChartView.holeRadiusPercent = 0.76
        pieChartView.transparentCircleRadiusPercent = 0.8
        pieChartView.transparentCircleColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.24)
        
        //highlight
        chartDataSet.selectionShift = 5
        
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
    //tap
    @IBAction func tapEditButton(_ sender: UIButton) {
        
        switch sender.state.rawValue {
        case 1:
            coreAnimation(true)
            popAnimation(true)
        default:
            coreAnimation(false)
            popAnimation(false)
        }
    }

    
    
    
    //animation
    func coreAnimation(_ sender: Bool) {
        let cardHeight:CGFloat = view.frame.height * 0.85
        var scale:CGFloat!
        var alpha:CGFloat!
        
        switch sender {
        case true:
            scale = 1
            alpha = 0.01
            self.editRecordBgWidth.constant = self.view.frame.width - 20
            self.editRecordBgHeight.constant = cardHeight
            self.editRecordBgBottom.constant = self.view.center.y - cardHeight/2
            self.editRecordButtonBottom.constant = 16
        default:
            scale = 0.01
            alpha = 1
            self.editRecordBgWidth.constant = buttonHeight
            self.editRecordBgHeight.constant = buttonHeight
            self.editRecordBgBottom.constant = buttonBottom
            self.editRecordButtonBottom.constant = 0
        }
        UIView.animate(withDuration: 0.3, delay: 0, options:.curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.editRecordButton.isSelected = sender
            self.navigationController?.navigationBar.alpha = alpha
            self.cardView.transform = CGAffineTransform(scaleX: 1, y: scale)
            self.cardView.alpha = scale
        }, completion: {_ in
        })
    }
    
    func popAnimation(_ sender:Bool) {
        var toColor:CGColor!
        var toRadius:Int!
        //        var toAlpha:CGFloat
        switch sender {
        case true:
            toColor = UIColor.white.cgColor
            toRadius = 4
        //            toAlpha = 0.8
        default:
            toColor = UIColor.clear.cgColor
            toRadius = 26
            //            toAlpha = 0.0
        }
        
        let bordedrAnimation = POPBasicAnimation(propertyNamed: kPOPLayerBorderColor)
        bordedrAnimation?.toValue = toColor
        bordedrAnimation?.duration = 0.3
        bordedrAnimation?.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        editRecordButton.layer.pop_add(bordedrAnimation, forKey: "borderColor")
        
        let cornerAnimation = POPBasicAnimation(propertyNamed: kPOPLayerCornerRadius)
        cornerAnimation?.toValue = toRadius
        cornerAnimation?.duration = 0.3
        cornerAnimation?.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        editRecordBg.layer.pop_add(cornerAnimation, forKey: "cornerRadius")
    }
}
