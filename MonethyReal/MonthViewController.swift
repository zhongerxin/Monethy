//
//  MonthViewController.swift
//  MonethyReal
//
//  Created by 钟信 on 2016/8/28.
//  Copyright © 2016年 zhongxin. All rights reserved.
//

import UIKit
import RealmSwift

class MonthViewController: UITableViewController {
    var currentDateToString = DateToString(nowDate:NSDate())
    var monthList: Results<MonthList>!
    
    override func viewWillAppear(animated: Bool) {
        readMonthListAndUpdateUI()
    }
    
    func readMonthListAndUpdateUI(){
        monthList = uiRealm.objects(MonthList)
        self.tableView.reloadData()
    }
    

    @IBAction func addMonth(sender: AnyObject) {
        self.performSegueWithIdentifier("showAdd", sender: self.monthList)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "showAdd":
            let addMonthViewController = segue.destinationViewController as! AddMonthViewController
            addMonthViewController.monthList = sender as! Results<MonthList>!
        case "showAccount":
            let accountViewController = segue.destinationViewController as! AccountViewController
            accountViewController.selectedMonth = sender as! MonthList!
        default:
            return
        }
        
//        if segue.identifier == "showAdd" {
//            let addMonthViewController = segue.destinationViewController as! AddMonthViewController
//            addMonthViewController.monthList = sender as! Results<MonthList>!
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let listsMonth = monthList {
            return listsMonth.count
        }
        return 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("monthCell", forIndexPath: indexPath)
        let month = monthList[indexPath.row]
        currentDateToString.nowDate = month.createdDate
        let date = currentDateToString
        cell.textLabel?.text = date.dateToString().year + date.dateToString().month
        cell.detailTextLabel?.text = "￥\(month.totalMoney)"
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.performSegueWithIdentifier("showAccount", sender: self.monthList[indexPath.row])
    }
}
