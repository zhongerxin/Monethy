//
//  SelectedDateViewController.swift
//  Monthey
//
//  Created by 钟信 on 2017/1/22.
//  Copyright © 2017年 zhongxin. All rights reserved.
//

import UIKit

class SelectedDateViewController: UIViewController {
    var stackSpacing:CGFloat!
    var pageTag:Int!
    //ui
    @IBOutlet weak var firstStack: UIStackView!
    @IBOutlet weak var secondStack: UIStackView!
    @IBOutlet var monthButtons: [UIButton]!

    override func viewDidLoad() {
        super.viewDidLoad()
        setMonthBUttons()
        secondStack.spacing = stackSpacing
        firstStack.spacing = stackSpacing
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func tapedMonthButton(_ sender: UIButton) {
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
    func setButtonDone(button:UIButton) {
        button.setBackgroundImage(#imageLiteral(resourceName: "done_bg"), for: .normal)
        button.setTitle("", for: .normal)
    }
    

}
