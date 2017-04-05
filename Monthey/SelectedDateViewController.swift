//
//  SelectedDateViewController.swift
//  Monthey
//
//  Created by 钟信 on 2017/1/22.
//  Copyright © 2017年 zhongxin. All rights reserved.
//

import UIKit

<<<<<<< HEAD
class SelectedDateViewController: UIViewController,SelectDateDelegate{
    
    var stackSpacing:CGFloat!
    var pageTag:Int!
    var delegate:AddRecordViewDelegate?
    //let
    let currentDate = NSDate()
=======
class SelectedDateViewController: UIViewController {
    var stackSpacing:CGFloat!
    var pageTag:Int!
>>>>>>> origin/master
    //ui
    @IBOutlet weak var firstStack: UIStackView!
    @IBOutlet weak var secondStack: UIStackView!
    @IBOutlet var monthButtons: [UIButton]!

    override func viewDidLoad() {
        super.viewDidLoad()
<<<<<<< HEAD
        setMonthButtons()
=======
        setMonthBUttons()
>>>>>>> origin/master
        secondStack.spacing = stackSpacing
        firstStack.spacing = stackSpacing
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func tapedMonthButton(_ sender: UIButton) {
<<<<<<< HEAD
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
        delegate?.setAddButtonActive()
    }
    
    //protocol
    func setMonthButtons() {
        let doneMonths = realm.objects(Month.self).filter("year = \(twoYearNumbers[pageTag])")
        for i in doneMonths {
            setButtonDone(button: monthButtons[i.month - 1])
        }
        if pageTag == 1 {
            let button = monthButtons[currentMonthNumber - 1]
            if button.title(for: .normal) != "" {
                print("设置按钮")
                button.isSelected = true
                button.setTitle("\(button.tag)", for: .selected)
                button.titleLabel?.font = UIFont(name: "PingFangSC-Semibold", size: 16)
                preTapedButton = button
            }
        }
    }
    
=======
    }
    
    //初始化
    func setMonthBUttons() {
        for i in monthButtons {
            if pageTag == 1 {
                if i.tag == 1 {
                    setButtonDone(button: i)
                }
            }
        }
    }
>>>>>>> origin/master
    func setButtonDone(button:UIButton) {
        button.setBackgroundImage(#imageLiteral(resourceName: "done_bg"), for: .normal)
        button.setTitle("", for: .normal)
    }
    

}
<<<<<<< HEAD

protocol SelectDateDelegate {
    func setMonthButtons()
}
=======
>>>>>>> origin/master
