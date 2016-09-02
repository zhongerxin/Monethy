//
//  AccountViewController.swift
//  MonethyReal
//
//  Created by 钟信 on 2016/8/30.
//  Copyright © 2016年 zhongxin. All rights reserved.
//

import UIKit
import RealmSwift
class AccountViewController: UITableViewController {
    var currentDateToString = DateToString(nowDate:NSDate())
    var nowAccounts:Results<Accounts>!
    var selectedMonth: MonthList!
    
    override func viewWillAppear(animated: Bool) {
        currentDateToString.nowDate = selectedMonth.createdDate
        let date = currentDateToString
        self.title = "\(date.dateToString().month)总额 \(selectedMonth.totalMoney)元"
        readAccountsAndUpateUI()
        print(selectedMonth.totalMoney)
    }
    
    func readAccountsAndUpateUI(){
        nowAccounts = selectedMonth.accounts.sorted("accountMoney", ascending: false)
        print(nowAccounts)
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readAccountsAndUpateUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    @IBAction func editButton(sender: AnyObject) {
        self.performSegueWithIdentifier("showEdit", sender: self.selectedMonth)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showEdit" {
            let addMonthViewController = segue.destinationViewController as! AddMonthViewController
            addMonthViewController.currentMonth = sender as! MonthList
        }
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return nowAccounts.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("accountCell", forIndexPath: indexPath)
        var account: Accounts!
        account = nowAccounts[indexPath.row]
        cell.textLabel?.text = account.accountName
        cell.detailTextLabel?.text = "￥" + String(account.accountMoney)
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
