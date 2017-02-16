//
//  ViewController.swift
//  Monthey
//
//  Created by 钟信 on 2016/11/24.
//  Copyright © 2016年 zhongxin. All rights reserved.
//

import UIKit
import pop
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate,RecordViewDelegate{
    
    var delegate:AddRecordViewDelegate?
    var pickerDelegate:PickerViewDelegate?
    //UI
    @IBOutlet weak var monthMoneyTable: UITableView!
    @IBOutlet weak var circleImage: UIImageView!
    @IBOutlet weak var navBarBg: UIView!
    @IBOutlet weak var topScroll: UIScrollView!
    @IBOutlet weak var pageControll: UIPageControl!
    
    @IBOutlet weak var addRecordBg: UIView!
    @IBOutlet weak var addRecordButton: UIButton!
    
    @IBOutlet weak var cardView: UIView!
    //layout
    @IBOutlet weak var addRecordBgWidth: NSLayoutConstraint!
    @IBOutlet weak var addRecordBgHeight: NSLayoutConstraint!
    @IBOutlet weak var addRecordBgBottom: NSLayoutConstraint!
    @IBOutlet weak var addRecordButtonBottom: NSLayoutConstraint!
    
    var buttonBottom:CGFloat!
    var buttonHeight:CGFloat!
    
    //var
    var months = realm.objects(Month.self)
    var accounts = realm.objects(Account.self)
    
    
    //let
    private let insetHeight:CGFloat = 232
    let pageControllers = [SumMoneyViewController(),YearChartViewController()]
    let pickerView = PickerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
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
        
        //addRecord初始化
        setAddRecord()
        
        //pickerView初始化
        setPickerView()
        
        //layout
        buttonHeight = addRecordBgHeight.constant
        buttonBottom = addRecordBgBottom.constant
        
        //通知
        NotificationCenter.default.addObserver(self,selector: #selector(self.keyboardWillChange(_:)),name: .UIKeyboardWillChangeFrame, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //初始化
    func setAddRecord() {
        addRecordButton.layer.borderColor = UIColor.clear.cgColor
        addRecordBg.layer.cornerRadius = 26
        addRecordBg.layer.shadowColor = UIColor(colorLiteralRed: 1/255, green: 40/255, blue: 98/255, alpha: 39/100).cgColor
        addRecordBg.layer.shadowOffset = CGSize(width: 0, height: 2)
        addRecordBg.layer.shadowRadius = 5
        addRecordBg.layer.shadowOpacity = 0.8
        cardView.alpha = 0.01
    }
    
    func setPickerView() {
        let frame = CGRect(x:CGFloat(0),y:CGFloat(view.frame.height + 1),width:view.frame.width,height:CGFloat(261))
        pickerView.view.frame = frame
        pickerView.delegate = self
        pickerDelegate = pickerView
        view.addSubview(pickerView.view)
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
            let frame = CGRect(x:view.bounds.width * CGFloat(i),y:0,width:scrollWidth,height:scrollHeight)
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
    func keyboardWillChange(_ notification: NSNotification) {
        if let userInfo = notification.userInfo,
            let value = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue,
            let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double,
            let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? UInt {
            let frame = value.cgRectValue
            var intersection = frame.intersection(self.view.frame)
            //当键盘消失，让view回归原始位置
            if intersection.height == 0.0 {
                intersection = CGRect(x: intersection.origin.x, y: intersection.origin.y, width: intersection.width, height: self.view.center.y - view.frame.height * 0.85/2 - 10)
            }
            addRecordBgBottom.constant = intersection.height + 10
            UIView.animate(withDuration: duration, delay: 0.0,
                           options: UIViewAnimationOptions(rawValue: curve), animations: {
                            _ in
                            //改变下约束
                            self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    
    //tap
    
    @IBAction func tapAddButton(_ sender: Any) {
        let  a = sender as! UIButton
        switch a.state.rawValue {
        case 1:
            delegate?.setShowAccounts()
            delegate?.setTableView()
            coreAnimation(true)
            popAnimation(true)
            delegate?.setScrollToCurrentYear()
        default:
            delegate?.resignTextField()
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
            self.addRecordBgWidth.constant = self.view.frame.width - 20
            self.addRecordBgHeight.constant = cardHeight
            self.addRecordBgBottom.constant = self.view.center.y - cardHeight/2
            self.addRecordButtonBottom.constant = 16
        default:
            scale = 0.01
            alpha = 1
            self.addRecordBgWidth.constant = buttonHeight
            self.addRecordBgHeight.constant = buttonHeight
            self.addRecordBgBottom.constant = buttonBottom
            self.addRecordButtonBottom.constant = 0
        }
        UIView.animate(withDuration: 0.3, delay: 0, options:.curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.addRecordButton.isSelected = sender
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
        addRecordButton.layer.pop_add(bordedrAnimation, forKey: "borderColor")
        
        let cornerAnimation = POPBasicAnimation(propertyNamed: kPOPLayerCornerRadius)
        cornerAnimation?.toValue = toRadius
        cornerAnimation?.duration = 0.3
        cornerAnimation?.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        addRecordBg.layer.pop_add(cornerAnimation, forKey: "cornerRadius")
    }
    
    //segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addRecord"  {
            let desinationController = segue.destination as! AddRecordCardViewController
            delegate = desinationController
            desinationController.delegate = self
        }
    }
    //protocol
    func cancelCard() {
        coreAnimation(false)
        popAnimation(false)
    }
    
    func appearPickerView(sender:Bool) {
        var frame:CGRect!
        var constant:CGFloat!
        switch sender {
        case true:
            frame = CGRect(x:CGFloat(0),y:CGFloat(view.frame.height - 261),width:view.frame.width,height:CGFloat(261))
            constant = frame.height + 10
            pickerDelegate?.reloadData()
        default:
            frame = CGRect(x:CGFloat(0),y:CGFloat(view.frame.height + 1),width:view.frame.width,height:CGFloat(261))
            constant = self.view.center.y - view.frame.height * 0.85/2
        }
        addRecordBgBottom.constant = constant
        UIView.animate(withDuration: 0.2, delay: 0, options:.curveEaseOut, animations: {
            self.pickerView.view.frame = frame
            self.view.layoutIfNeeded()
        }, completion: {_ in
        })
    }
}

protocol RecordViewDelegate {
    func cancelCard()
    func appearPickerView(sender:Bool)
}

