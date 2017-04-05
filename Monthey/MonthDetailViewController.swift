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
import RealmSwift

class MonthDetailViewController: UIViewController , UITableViewDelegate, UITableViewDataSource, ChartViewDelegate{
    //ui
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var accountsTableView: UITableView!
    @IBOutlet weak var createTimeLabel: UILabel!
    @IBOutlet weak var accountIsDeleteLabel: UILabel!
    @IBOutlet weak var accountNameLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    
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
    
    var month:Month!
    var accounts = [String]()
    var moneyNumbers = [Double]()
    var notificationToken: NotificationToken? = nil
    var records:Results<Record>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pieChartView.delegate = self
        records = month.records.sorted(byProperty: "amount", ascending: false)
        notificationToken = records.addNotificationBlock { changes in
            switch changes {
            case .initial( _):
                break
            case .update(_ , _, _, _):
                self.setPieCharts()
                break
            case .error:
                break
            }
        }
        //TableView初始化
        accountsTableView.separatorStyle = .none
        accountsTableView.contentInset.top = -150
        accountsTableView.contentInset.bottom = 10
        setCreateTimeLabel()
        setAccountNameLabel()
        setPercentLabel()
        setAccountIsDeleteLabel(isHidden:true)
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
    override func viewWillAppear(_ animated: Bool) {
        setPieCharts()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //初始化
    func setCreateTimeLabel(){
        let monthNumber = DateToString(currentDate: month.createdAt as Date).dateToString().month
        let dayNumber = DateToString(currentDate: month.createdAt as Date).dateToString().day
        createTimeLabel.text = "\(monthNumber)月\(dayNumber)日 记录"
    }
    func setAccountNameLabel(){
        let monthNumber = month.month
        accountNameLabel.text = "\(monthNumber)月资产 (元)"
    }
    func setPercentLabel(){
        percentLabel.text = "\(month.totalAmount)"
    }
    func setAccountIsDeleteLabel(isHidden:Bool){
        accountIsDeleteLabel.isHidden = isHidden
    }
    
    //渐变
    func setPieCharts(){
        for i in records{
            accounts.append(i.accountOwners[0].name)
            moneyNumbers.append(i.amount)
        }
        setChart(dataPoints: accounts, values: moneyNumbers)
        print(moneyNumbers)
    }
    
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
        let number = entry.y / Double(month.totalAmount) * 100
        if number < 1 {
            percentLabel.text = String(format: "%.1f", number) + "%"
        } else {
            percentLabel.text = String(format: "%.0f", number) + "%"
        }
        print(highlight)
        let index = Int(highlight.x)
        let accountName = records[index].accountOwners.first?.name
        accountNameLabel.text = "\(accountName!): " + String(format: "%.1f", entry.y) + "元"
    }
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        print("没有选择")
    }
    
    //table
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return records.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "accountCell", for: indexPath) as! AccountRecordCell
        let record = records[indexPath.row]
        cell.accountName.text = record.accountOwners.first?.name
        cell.monthAmount.text = String(format: "%.1f", record.amount) + "元"
        if indexPath.row == records.count - 1 {
            cell.dashLine.isHidden = true
        }
        return cell
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let  footerCell = tableView.dequeueReusableCell(withIdentifier: "footerCell")
        return footerCell
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 7.0
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
