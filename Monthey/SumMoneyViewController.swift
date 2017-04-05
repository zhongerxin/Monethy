//
//  SumMoneyViewController.swift
//  Monthey
//
//  Created by 钟信 on 2016/12/6.
//  Copyright © 2016年 zhongxin. All rights reserved.
//

import UIKit
import RealmSwift

class SumMoneyViewController: UIViewController {
    @IBOutlet weak var sumMoneyLabel: UILabel!
    var currentYearNumber = 0
    let currentDate = NSDate()
    var sortMonths = realm.objects(Month.self)
    var notificationToken: NotificationToken? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        currentYearNumber = DateToString(currentDate: currentDate as Date).dateToString().year
        sortMonths = realm.objects(Month.self).filter("year = \(currentYearNumber)").sorted(byProperty: "month", ascending: false)
        print(sortMonths)
        setSumMoneyLabel()
        notificationToken = sortMonths.addNotificationBlock { changes in
            switch changes {
            case .initial( _):
                break
            case .update(_ , _, _, _):
                self.setSumMoneyLabel()
                break
            case .error:
                break
            } 
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
<<<<<<< HEAD
    
    func setSumMoneyLabel(){
        if sortMonths.count > 1 {
            print("总结")
            sumMoneyLabel.text = String(sortMonths[0].totalAmount)
        } else {
            sumMoneyLabel.text = "0"
        }
    }
=======

>>>>>>> origin/master

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
