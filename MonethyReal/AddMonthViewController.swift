//
//  AddMonthViewController.swift
//  MonethyReal
//
//  Created by 钟信 on 2016/8/28.
//  Copyright © 2016年 zhongxin. All rights reserved.
//

import UIKit
import RealmSwift

class AddMonthViewController: UITableViewController {
    
    var monthList: Results<MonthList>!
    var currentMonth: MonthList!
    var addAccountList = List<Accounts>()
    var currentCreateAction:UIAlertAction!
    var isAccountNameRight = false
    
    @IBOutlet weak var navBar: UINavigationBar!
    
    
    
    override func prefersStatusBarHidden()->Bool{
    
    return true
    
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navBar.topItem?.title = "新增记账月"
        readAccountsAndUpateUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    func readAccountsAndUpateUI(){
        if currentMonth != nil {
            for item in currentMonth.accounts {
                addAccountList.append(item)
            }
            print("currentMonth不为nil\(addAccountList)")
        }
        self.tableView.reloadData()
    }

    @IBAction func cancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func saveButton(sender: AnyObject) {
        let newMonth = MonthList()
        for cell in tableView.visibleCells{
            if let date = cell.viewWithTag(100) {
                let toDate = date as! UIDatePicker
                print("\(currentMonth)")
                if currentMonth == nil {
                    newMonth.createdDate = toDate.date
                    try! uiRealm.write{
                        uiRealm.add(newMonth)
                        print("add 成功")
                    }
                    try! uiRealm.write{
                        var totalMoney = 0
                        for item in addAccountList {
                            newMonth.accounts.append(item)
                            totalMoney += item.accountMoney
                        }
                        newMonth.totalMoney = totalMoney
                    }
                } else {
                    try! uiRealm.write{
                        self.currentMonth.setValue(addAccountList, forKey: "accounts")
                        self.currentMonth.createdDate = toDate.date
                        print("update 成功")
                    }
                    try! uiRealm.write{
                        var totalMoney = 0
                        for item in addAccountList {
                            totalMoney += item.accountMoney
                        }
                        currentMonth.totalMoney = totalMoney
                    }
                }
            }
        }
        dismissViewControllerAnimated(true, completion: nil)
        print("save")
    }
    @IBAction func addAccountButton(sender: AnyObject) {
        displayAlertToAddAccount(nil)
    }
    
    func displayAlertToAddAccount(updatedAccount:Int!){
        
        var title = "New Account"
        var doneTitle = "Create"
        if updatedAccount != nil{
            title = "Update Account"
            doneTitle = "Update"
        }
        
        let alertController = UIAlertController(title: title, message: "Input the account and money", preferredStyle: UIAlertControllerStyle.Alert)
        let createAction = UIAlertAction(title: doneTitle, style: UIAlertActionStyle.Default) { (action) -> Void in
            
            let accountName = alertController.textFields?[0].text
            var accountMoney = alertController.textFields?[1].text
            if updatedAccount != nil{
                // update mode
                try! uiRealm.write{
                    self.addAccountList[updatedAccount].setValue(accountName!, forKey: "accountName")
                    print("s1")
                    self.addAccountList[updatedAccount].setValue(Int(accountMoney!), forKey: "accountMoney")
                    print("s2")
                    self.tableView.reloadData()
                }
                
            }
            else if self.currentMonth == nil{
                
                let newAccount = Accounts()
                newAccount.accountName = accountName!
                self.stringToInt(&accountMoney!, intValue: &newAccount.accountMoney, isStoI: true)
                self.addAccountList.append(newAccount)
                self.readAccountsAndUpateUI()
            } else {
                let newAccount = Accounts()
                newAccount.accountName = accountName!
                self.stringToInt(&accountMoney!, intValue: &newAccount.accountMoney, isStoI: true)
                try! uiRealm.write{
                    self.addAccountList.append(newAccount)
                    self.tableView.reloadData()
                    print("zengjia 成功")
                }
            }
            self.isAccountNameRight = false
        }
        
        alertController.addAction(createAction)
        createAction.enabled = false
        self.currentCreateAction = createAction
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "账户名"
            textField.addTarget(self, action: #selector(self.isAccountNameRight(_:)) , forControlEvents: UIControlEvents.EditingChanged)
            if updatedAccount != nil{
                textField.text = self.addAccountList[updatedAccount].accountName
                self.isAccountNameRight = true
            }
        }
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "金额"
            textField.addTarget(self, action: #selector(self.isAccountMoneyRight(_:)) , forControlEvents: UIControlEvents.EditingChanged)
            if updatedAccount != nil{
                textField.text = String(self.addAccountList[updatedAccount].accountMoney)
            }
        }
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func isAccountNameRight(textField:UITextField){
        self.isAccountNameRight = textField.text?.characters.count > 0
    }
    func isAccountMoneyRight(textField:UITextField){
        if isAccountNameRight {
            if let value = Int(textField.text!) {
                if value > 0 {
                    self.currentCreateAction.enabled = true
                }
            }
        }
    }
    
    func stringToInt(inout stringValue:String, inout intValue:Int, isStoI:Bool) {
        if isStoI {
            if let number = Int(stringValue) {
                intValue = number
            } else {print("字符串转换为整数失败")}
        } else {
            stringValue = String(intValue)
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return addAccountList.count
        }
        
        return 1
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var account:Accounts!
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("accountAddCell", forIndexPath: indexPath)
            account = addAccountList[indexPath.row]
            cell.textLabel?.text = account.accountName
            cell.detailTextLabel?.text = "￥" + String(account.accountMoney)
            return cell
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("timePickerCell", forIndexPath: indexPath) as! PickerViewCell
        if currentMonth != nil {
            cell.pickerButton.date = currentMonth.createdDate
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            let footerCell = tableView.dequeueReusableCellWithIdentifier("addButtonCell")
            return footerCell
        }
        

        return nil
        
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "账户"
        }
        return "时间"
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 44
        default:
            return 200
        }
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Destructive, title: "Delete") { (deleteAction, indexPath) -> Void in
            
            //Deletion will go here
            self.addAccountList.removeAtIndex(indexPath.row)
            self.tableView.reloadData()
        }
        let editAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Edit") { (editAction, indexPath) -> Void in
//            var accountToBeUpdate: Accounts!
//            accountToBeUpdate = self.addAccountList[indexPath.row]
            self.displayAlertToAddAccount(indexPath.row)
        }
        return [deleteAction, editAction]
    }

}
