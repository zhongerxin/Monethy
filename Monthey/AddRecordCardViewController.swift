//
//  AddRecordCardViewController.swift
//  Monthey
//
//  Created by 钟信 on 2017/1/17.
//  Copyright © 2017年 zhongxin. All rights reserved.
//

import UIKit
import RealmSwift
import Dispatch

class AddRecordCardViewController: UIViewController,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,AddRecordViewDelegate {
    
    //var
    var delegate:RecordViewDelegate?
    var cellDeleagte:RecordsTableViewCell?
    
    var currentYearNumber = 0
    var threeYearNumbers = [Int]()
    
    var preTapedButton:UIButton!
    
    var accounts = realm.objects(Account.self)
    var activeAccounts = realm.objects(Account.self).filter("isDelete = false")
    var showAccounts = realm.objects(Account.self).filter("isShow = true AND isDelete = false")
    
    var notificationToken: NotificationToken? = nil

    //ui
    @IBOutlet weak var selectDateScroll: UIScrollView!
    @IBOutlet weak var pageControll: UIPageControl!
    @IBOutlet weak var recordsTableview: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    
    //let
    private let insetHeight:CGFloat = 86
    let currentDate = NSDate()    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(showAccounts)
        //初始化时间
        currentYearNumber = DateToString(currentDate: currentDate as Date).dateToString().year
        threeYearNumbers = [currentYearNumber - 1,currentYearNumber,currentYearNumber + 1]
        setDateScroll()
        recordsTableview.contentInset.bottom = insetHeight
        //通知
        notificationToken = showAccounts.addNotificationBlock { changes in
            switch changes {
            case .initial( _):
                break
            case .update(_ , let deletions, _, _):
//                self.recordsTableview.beginUpdates()
                if deletions == [] {
                    self.recordsTableview.reloadData()
                }
//                self.recordsTableview.endUpdates()
                break
            case .error:
                break
            }
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //tableview
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showAccounts.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recordCell", for: indexPath) as! RecordsTableViewCell
        cellDeleagte = cell
        cell.addOrMinusButton.addTarget(self, action:#selector(self.touchUpMinusButton(sender:)) , for: .touchUpInside)
        
        if indexPath.row == showAccounts.count{
            print("我是",indexPath.row)
            cellDeleagte?.setCellToInsertRow()
            if showAccounts.count == activeAccounts.count {
                cell.isHidden = true
            }
            return cell
        }
        let account = showAccounts[indexPath.row]
        cell.accountNameLabel.text = account.name
        cell.addOrMinusButton.tag = account.id
        cellDeleagte?.setDefaultRow()
        return cell
    }
    
    func touchUpMinusButton(sender: UIButton){
        
        var indexPath: IndexPath!
            if let superview = sender.superview {
                if let cell = superview.superview as? RecordsTableViewCell {
                    indexPath = recordsTableview.indexPath(for: cell) as IndexPath!
                }
            }
        
        switch sender.state.rawValue {
            case 1:
                let account = showAccounts[indexPath.row]
                let serialQueue = DispatchQueue(label: "Mazy", attributes: .init(rawValue: 0))
                serialQueue.sync {
                    try! realm.write{
                        account.isShow = false
                    }
                }
                serialQueue.sync {
                    recordsTableview.deleteRows(at: [indexPath], with: .automatic)
                }
                serialQueue.sync {
                    if showAccounts.count == activeAccounts.count - 1{
                        self.recordsTableview.reloadData()
                    }
                }
            default:
                delegate?.appearPickerView(sender:true)
        }
    }
    
    //初始化
    func setDateScroll() {
        let scrollHeight:CGFloat = selectDateScroll.frame.height
        let scrollWidth = selectDateScroll.frame.width
        let viewWidth = view.bounds.width - 20
        print(viewWidth)
        print(scrollWidth)
        selectDateScroll.contentSize =  CGSize(width:3*viewWidth,height:scrollHeight)
        selectDateScroll.autoresizingMask = [.flexibleWidth]
        selectDateScroll.isPagingEnabled = true
        for i in 0 ..< 3 {
            let frame = CGRect(x:CGFloat(viewWidth * CGFloat(i)),y:CGFloat(0),width:scrollWidth,height:scrollHeight)
            let subView = SelectedDateViewController()
            subView.stackSpacing = viewWidth * 18 / 355
            subView.pageTag = i
            subView.view.tag = i
            subView.view.frame = frame
            selectDateScroll.addSubview(subView.view)
        }
    }
    
    func setShowAccounts() {
        for account in activeAccounts {
            try! realm.write{
                account.isShow = true
            }
        }
        recordsTableview.reloadData()
    }
    
    //交互
    @IBAction func tapedMonthButton(_ sender: UIButton) {
        if sender.title(for: .normal) != "" {
            if let button = preTapedButton {
                button.isSelected = false
                button.titleLabel?.font = UIFont(name: "PingFang SC", size: 14)
            }
            sender.isSelected = true
            sender.setTitle("\(sender.tag)", for: .selected)
            sender.titleLabel?.font = UIFont(name: "PingFangSC-Semibold", size: 16)
            preTapedButton = sender
        }
        if sender.superview?.superview?.superview?.tag == 0 {
            print("我是第一页")
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let xOffset = selectDateScroll.contentOffset.x
        print(xOffset)
        switch xOffset {
        case _ where xOffset < selectDateScroll.frame.width:
            pageControll.currentPage = 0
        case selectDateScroll.frame.width ..< 2 * selectDateScroll.frame.width:
            pageControll.currentPage = 1
        default:
            pageControll.currentPage = 2
        }
        titleLabel.text = "\(threeYearNumbers[pageControll.currentPage])年"
    }
    
    @IBAction func didTapCancelButton(_ sender: Any) {
        delegate?.cancelCard()
        resignTextField()
    }
    
    //protocol
    
    func setScrollToCurrentYear(){
        selectDateScroll.contentOffset.x = selectDateScroll.frame.width
        pageControll.currentPage = 1
        titleLabel.text = "\(currentYearNumber)年"
    }
    
    func resignTextField(){
        view.endEditing(true)
    }
    
    func setTableView() {
        recordsTableview.contentOffset.y = 0
    }
}

protocol AddRecordViewDelegate {
    func setScrollToCurrentYear()
    func resignTextField()
    func setShowAccounts()
    func setTableView()
}
