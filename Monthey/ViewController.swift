//
//  ViewController.swift
//  Monthey
//
//  Created by 钟信 on 2016/11/24.
//  Copyright © 2016年 zhongxin. All rights reserved.
//

import UIKit
import pop

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate{
    //UI
    @IBOutlet weak var monthMoneyTable: UITableView!
    @IBOutlet weak var circleImage: UIImageView!
    @IBOutlet weak var navBarBg: UIView!
    @IBOutlet weak var topScroll: UIScrollView!
    @IBOutlet weak var pageControll: UIPageControl!
    
    //var
    
    //let
    private let insetHeight:CGFloat = 232
    let pageControllers = [SumMoneyViewController(),YearChartViewController()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UI初始化
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        navBarBg.alpha = 0
        
        //TableView初始化
        monthMoneyTable.contentInset.top = insetHeight
        monthMoneyTable.separatorStyle = .none
        
        //ScrollView和Pagecontroll初始化
        setTopScroll()
        pageControll.numberOfPages = pageControllers.count
        pageControll.defersCurrentPageDisplay = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //数据部分
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "monthMoneyCell", for: indexPath)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toMonthDetail", sender: indexPath)
    }
    
    
    //交互部分
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let startValue:CGFloat = 10
        let endValue:CGFloat = 80
        let offSet = monthMoneyTable.contentOffset.y + insetHeight
        
        var valueSet = 1 - (offSet - startValue) / (endValue - startValue)
        
        switch offSet {
        case startValue ..< endValue:
            scrollAnimation(valueAlpha: valueSet, valueScale: valueSet/2 + 0.5)
        case _ where offSet >= endValue:
            valueSet = 0
            scrollAnimation(valueAlpha: valueSet, valueScale: valueSet/2 + 0.5)
        case _ where offSet < startValue - 10:
            scrollAnimation(valueAlpha: 1, valueScale: valueSet * 0.1 + 0.9)
        default:
            valueSet = 1
            scrollAnimation(valueAlpha: valueSet, valueScale: valueSet)
        }
        //控制navbar
        switch offSet {
        case _ where offSet >= endValue:
            scrollAlphaAnimation(toValue: 1, animateView: navBarBg, duration:0.2)
        default:
            scrollAlphaAnimation(toValue: 0, animateView: navBarBg, duration:0.2)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let xOffset = topScroll.contentOffset.x
        switch xOffset {
        case _ where xOffset < topScroll.frame.width/2:
            pageControll.currentPage = 0
            scrollAlphaAnimation(toValue: 1, animateView: circleImage, duration:0.5)
        default:
            pageControll.currentPage = 1
            scrollAlphaAnimation(toValue: 0, animateView: circleImage, duration:0.5)
        }
    }

    
    func scrollAnimation(valueAlpha:CGFloat,valueScale:CGFloat) {
        topScroll.alpha = valueAlpha
        pageControll.alpha = valueAlpha
        topScroll.transform = CGAffineTransform(scaleX: valueScale, y: valueScale)
        pageControll.transform = CGAffineTransform(scaleX: valueScale, y: valueScale)
        
        if pageControll.currentPage == 0 {
            circleImage.alpha = valueAlpha
            circleImage.transform = CGAffineTransform(scaleX: valueScale, y: valueScale)
        }
    }
    
    func scrollAlphaAnimation(toValue:CGFloat, animateView:UIView, duration:CFTimeInterval) {
        let animation = POPBasicAnimation(propertyNamed: kPOPLayerOpacity)
        animation?.toValue = toValue
        animation?.duration = duration
        animation?.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animateView.layer.pop_add(animation, forKey: "opacity")
    }
    
    
    func setTopScroll() {
        let scrollHeight = topScroll.frame.height
        let scrollWidth = topScroll.frame.width
        topScroll.contentSize =  CGSize(width:2*view.bounds.width,height:scrollHeight)
        topScroll.autoresizingMask = [.flexibleWidth , .flexibleHeight]
        topScroll.isPagingEnabled = true
        
        for i in 0 ..< 2 {
            let frame = CGRect(x:CGFloat(view.bounds.width * CGFloat(i)),y:CGFloat(0),width:scrollWidth,height:CGFloat(scrollHeight))
            switch i {
            case 0:
                let subView = pageControllers[i] as! SumMoneyViewController
                subView.sumMoney = "999"
                subView.view.frame = frame
                topScroll.addSubview(subView.view)
            default:
                let subView = pageControllers[i] as! YearChartViewController
                subView.view.frame = frame
                topScroll.addSubview(subView.view)
            }
        }
    }


    


}

