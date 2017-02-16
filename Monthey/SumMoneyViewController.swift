//
//  SumMoneyViewController.swift
//  Monthey
//
//  Created by 钟信 on 2016/12/6.
//  Copyright © 2016年 zhongxin. All rights reserved.
//

import UIKit
class SumMoneyViewController: UIViewController {
    @IBOutlet weak var sumMoneyLabel: UILabel!
    var sumMoney:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        sumMoneyLabel.text = sumMoney
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
