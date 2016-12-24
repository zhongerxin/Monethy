//
//  YearChartViewController.swift
//  Monthey
//
//  Created by 钟信 on 2016/12/8.
//  Copyright © 2016年 zhongxin. All rights reserved.
//

import UIKit
import Charts
import pop

class YearChartViewController: UIViewController, IAxisValueFormatter, ChartViewDelegate {
    
    @IBOutlet weak var barChartView: BarChartView!
    
    var months:[String]!
    
    let markerView = UIView()
    let markerBg = UIImageView(image: #imageLiteral(resourceName: "marker_bg"))
    let valueLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        barChartView.delegate = self
        months = ["1月", "2月", "3月", "4月", "5月", "6月", "7月", "8月", "9月", "10月", "11月", "12月"]
        let moneyNumbers = [5000.0, 5000.0, 5000.0, 5000.0, 2000.0, 5000.0, 9000.0, 4000.0, 5000.0, 5000.0, 5000.0, 5000.0]
        setChart(dataPoints: months, values: moneyNumbers)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        
        //data
        var dataEntries: [BarChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i) , y: values[i])
            dataEntries.append(dataEntry)
        }
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "")
        let chartData = BarChartData(dataSets: [chartDataSet])
        barChartView.xAxis.valueFormatter = self
        barChartView.data = chartData
        
        //UI
        barChartView.noDataText = ""
        barChartView.chartDescription?.text = ""
        
        barChartView.xAxis.labelCount = months.count
        barChartView.xAxis.labelPosition = .bottom
        barChartView.xAxis.labelTextColor = UIColor(colorLiteralRed: 1, green: 1, blue: 1, alpha: 0.7)
        barChartView.xAxis.labelFont = UIFont (name: "PingFang SC", size: 12)!
        barChartView.xAxis.labelRotatedHeight = 16
        barChartView.xAxis.drawAxisLineEnabled = false
        barChartView.xAxis.drawGridLinesEnabled = false
        
        barChartView.legend.enabled = false
        
        barChartView.gridBackgroundColor = .clear
        barChartView.backgroundColor = .clear
        
        barChartView.leftAxis.enabled = false
        barChartView.rightAxis.enabled = false
        
        barChartView.leftAxis.axisMinimum = 0.0
        
        chartDataSet.drawValuesEnabled = false
        chartDataSet.setColor(UIColor.white)
        chartData.barWidth = 0.52
        
        
        
        
        //highLight
        chartDataSet.highlightColor = UIColor(colorLiteralRed: 0, green: 136/255, blue: 1, alpha: 1)
        chartDataSet.highlightAlpha = CGFloat(1)
        barChartView.highlightValue(x: 1, dataSetIndex: 1, stackIndex: 1)
        barChartView.highlightPerTapEnabled = true
        barChartView.highlightPerDragEnabled = false
        
        //interaction
        barChartView.doubleTapToZoomEnabled = false
        barChartView.pinchZoomEnabled = false
        barChartView.setScaleEnabled(false)
        
        //marker
        barChartView.drawMarkers = true
        
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        
        let formattedString: String
        formattedString = months[Int(value)]
        return formattedString
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
       
        let markerWidth = CGFloat(String(highlight.y).characters.count) * 8.0 + 15.0
        let markerHeight:CGFloat = 20.0
        let xOffset = markerWidth/2 - 12
        let yOffset = markerHeight/2 + 1.5
        let markerY = highlight.yPx
        
        valueLabel.textAlignment = .center
        valueLabel.font = UIFont (name: "PingFangSC-Semibold", size: 12)!
        valueLabel.textColor = UIColor.white

        markerView.backgroundColor = UIColor.black
        markerView.layer.cornerRadius = 2.0
        markerView.addSubview(markerBg)
        markerView.addSubview(valueLabel)
        
        markerAnimation(toValue: 0, animateView: markerView, duration: 0.2,completion: { _ in
            self.valueLabel.frame = CGRect(x: 0, y: 0, width: markerWidth, height: markerHeight)
            self.markerView.frame = self.valueLabel.frame
            switch highlight.x {
            case 0.0:
                self.markerView.center = CGPoint(x:highlight.xPx + xOffset  , y:markerY)
                self.markerBg.center = CGPoint(x:12.0 , y:yOffset)
            case 11.0:
                self.markerView.center = CGPoint(x:highlight.xPx - xOffset , y:markerY)
                self.markerBg.center = CGPoint(x:markerWidth - 12 , y:yOffset)
            default:
                self.markerView.center = CGPoint(x:highlight.xPx , y:markerY)
                self.markerBg.center = CGPoint(x:markerWidth/2 , y:yOffset)
            }
            self.valueLabel.text = "￥" + String(highlight.y)
            self.view.addSubview(self.markerView)
            self.markerAnimation(toValue: 1, animateView: self.markerView, duration: 0.2, completion: {_ in})
        })
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        self.markerAnimation(toValue: 0, animateView: self.markerView, duration: 0.2, completion: {_ in})
    }
    
    func markerAnimation(toValue:CGFloat, animateView:UIView, duration:CFTimeInterval, completion: @escaping (POPAnimation?,Bool) -> Void) {
        let animation = POPBasicAnimation(propertyNamed: kPOPLayerOpacity)
        let scaleAnimation = POPBasicAnimation(propertyNamed: kPOPLayerScaleXY)
        
        scaleAnimation?.toValue = 1
        scaleAnimation?.duration = duration
        scaleAnimation?.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        animation?.toValue = toValue
        animation?.duration = duration
        animation?.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
//        animateView.layer.pop_add(scaleAnimation, forKey: "size")
        animateView.layer.pop_add(animation, forKey: "opacity")
        animation?.completionBlock = completion
    }


}
