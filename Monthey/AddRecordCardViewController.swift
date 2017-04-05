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


var preTapedButton:UIButton!
var currentMonthNumber = 0
var saveMonthNumber = 0
var twoYearNumbers = [Int]()
var recordsAmountInputs = [String]()

class AddRecordCardViewController: UIViewController,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,AddRecordViewDelegate {
    
    //var
    var delegate:RecordViewDelegate?
    var cellDeleagte:RecordsTableViewCell?
    var selectDlegate1:SelectDateDelegate?
    var selectDlegate2:SelectDateDelegate?
    
    var currentYearNumber = 0

    var accounts = realm.objects(Account.self)
    var activeAccounts = realm.objects(Account.self).filter("isDelete = false")
    var showAccounts = realm.objects(Account.self).filter("isShow = true AND isDelete = false")
    
    var notificationToken: NotificationToken? = nil
    
    var saveYearNumber = 0
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
        //初始化时间
        currentYearNumber = DateToString(currentDate: currentDate as Date).dateToString().year
        twoYearNumbers = [currentYearNumber - 1,currentYearNumber]
        currentMonthNumber = DateToString(currentDate: currentDate as Date).dateToString().month
        
        setDateScroll()
        recordsTableview.contentInset.bottom = insetHeight
        //通知
        notificationToken = showAccounts.addNotificationBlock { changes in
            switch changes {
            case .initial( _):
                break
            case .update(_ , let deletions, let insertions, let modifications):
//                self.recordsTableview.beginUpdates()
                print(deletions,insertions)
                for i in deletions {
                    recordsAmountInputs.remove(at: i)
                }
                for i in insertions {
                    recordsAmountInputs.insert("", at: i)
                }
                print(recordsAmountInputs)
                if deletions == [] && modifications == [] {
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
        cell.delegate = self
        if indexPath.row == showAccounts.count{
            cellDeleagte?.setInputAmountField()
            cellDeleagte?.setCellToInsertRow()
            if showAccounts.count == activeAccounts.count {
                cell.isHidden = true
            }
            return cell
        }
        let account = showAccounts[indexPath.row]
        cell.accountNameLabel.text = account.name
        cell.addOrMinusButton.tag = account.id
        cell.inputAmountField.text = recordsAmountInputs[indexPath.row]
        cellDeleagte?.setDefaultRow()
        if cell.inputAmountField.text == "" {
            cellDeleagte?.setInputAmountField()
        }
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
        selectDateScroll.contentSize =  CGSize(width:2*viewWidth,height:scrollHeight)
        selectDateScroll.autoresizingMask = [.flexibleWidth]
        selectDateScroll.isPagingEnabled = true
        for i in 0 ..< 2 {
            let frame = CGRect(x:CGFloat(viewWidth * CGFloat(i)),y:CGFloat(0),width:scrollWidth,height:scrollHeight)
            let subView = SelectedDateViewController()
            subView.delegate = self
            switch i {
            case 0:
                selectDlegate1 = subView
            default:
                selectDlegate2 = subView
            }
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
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let xOffset = selectDateScroll.contentOffset.x
        switch xOffset {
        case _ where xOffset < selectDateScroll.frame.width:
            pageControll.currentPage = 0
        default:
            pageControll.currentPage = 1
        }
        titleLabel.text = "\(twoYearNumbers[pageControll.currentPage])年"
        saveYearNumber = twoYearNumbers[pageControll.currentPage]
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
        saveYearNumber = currentYearNumber
    }
    
    
    func resignTextField(){
        view.endEditing(true)
    }
    
    func setTableView() {
        recordsTableview.contentOffset.y = 0
    }
    func addRecordsToRealm() {
        let month = Month()
        month.createdAt = currentDate
        month.year = saveYearNumber
        if preTapedButton != nil {
            saveMonthNumber = preTapedButton.tag
        }
        month.month = saveMonthNumber
        try! realm.write {
            realm.add(month)
        }
        print(saveYearNumber,saveMonthNumber)
        for i in 0 ..< showAccounts.count {
//            let indexPath = IndexPath(row: i, section: 0)
//            print(indexPath)
//            let cell = recordsTableview.cellForRow(at: indexPath) as! RecordsTableViewCell
            let account = showAccounts[i]
            var amount = 0.0
            let amountText = recordsAmountInputs[i]
            if let doubleAmount = Double(amountText) {
                amount = doubleAmount
            }
            let record = Record()
            record.createdAt = currentDate
            record.amount = amount
            try! realm.write {
                account.records.append(record)
                month.records.append(record)
            }
            print("yici")
            print(account.name,amountText,amount)
        }
        print(month.totalAmount)
    }
    func setMonthButton() {
        selectDlegate2?.setMonthButtons()
    }
    
    func resetMonthButton(){
        print(3)
        if preTapedButton != nil {
            preTapedButton.isSelected = false
            preTapedButton.titleLabel?.font = UIFont(name: "PingFang SC", size: 14)
            saveMonthNumber = 0
        }
    }
    
    func setAddButtonActive(){
        delegate?.isAddButtonActive(sender:true)
    }
    
    func setRecordsAmountInputs(){
        var inputs = [String]()
        for _ in showAccounts {
            inputs.append("")
        }
        recordsAmountInputs = inputs
    }
    
    func setCellToIndexPath(cell:RecordsTableViewCell){
        let indexPath = recordsTableview.indexPath(for: cell) as IndexPath!
        if let row = indexPath?.row {
            if let text = cell.inputAmountField.text {
                recordsAmountInputs[row] = text
            } else {
                recordsAmountInputs[row] = ""
            }
        }
    }
}

protocol AddRecordViewDelegate {
    func setScrollToCurrentYear()
    func resignTextField()
    func setShowAccounts()
    func setTableView()
    func addRecordsToRealm()
    func setMonthButton()
    func resetMonthButton()
    func setAddButtonActive()
    func setRecordsAmountInputs()
    func setCellToIndexPath(cell:RecordsTableViewCell)
}
