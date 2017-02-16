//
//  AddAccountViewController.swift
//  Monthey
//
//  Created by 钟信 on 2017/1/5.
//  Copyright © 2017年 zhongxin. All rights reserved.
//

import UIKit
import RealmSwift

class AddAccountViewController: UIViewController,AddAccountViewDelegate,UIScrollViewDelegate, UITextFieldDelegate {
    //var
    var delegate:AccountViewDelegate?
    var accounts = realm.objects(Account.self)
    
    //ui
    @IBOutlet weak var inputAccountName: UITextField!
    @IBOutlet weak var selectColorScroll: UIScrollView!
    @IBOutlet weak var pageControll: UIPageControl!
    //let
    let cardImages = [#imageLiteral(resourceName: "card_orange"),#imageLiteral(resourceName: "crad_green"),#imageLiteral(resourceName: "crad_blue")]
    let limitLength = 10
    let cardColors = ["orange","green","blue"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setColorScroll()
        setInputAccountName()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addAccount" {
           let ac = segue.destination as! AccountsViewController
            ac.delegate = self
        }
    }
    
    func setColorScroll() {
        let scrollHeight:CGFloat = 173
        let scrollWidth = view.bounds.width - 20
        selectColorScroll.contentSize =  CGSize(width:3*scrollWidth,height:scrollHeight)
        selectColorScroll.autoresizingMask = [.flexibleWidth]
        selectColorScroll.isPagingEnabled = true
        for i in 0 ..< 3 {
            let frame = CGRect(x:CGFloat(scrollWidth * CGFloat(i)),y:CGFloat(0),width:scrollWidth,height:scrollHeight)
            let subView = UIImageView(image:cardImages[i])
            subView.contentMode = .center
            subView.frame = frame
            selectColorScroll.addSubview(subView)
        }
    }
    func setInputAccountName() {
        inputAccountName.attributedPlaceholder = NSAttributedString(string: "请输入账户名称", attributes:[NSForegroundColorAttributeName: UIColor(colorLiteralRed: 1, green: 1, blue: 1, alpha: 60/100)])
        inputAccountName.alpha = 0
        inputAccountName.delegate = self
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let xOffset = selectColorScroll.contentOffset.x
        print(xOffset)
        switch xOffset {
        case _ where xOffset < selectColorScroll.frame.width:
            pageControll.currentPage = 0
        case selectColorScroll.frame.width ..< 2 * selectColorScroll.frame.width:
            pageControll.currentPage = 1
        default:
            pageControll.currentPage = 2
        }
    }
    @IBAction func didTapCancelButton(_ sender: Any) {
        delegate?.cancelCard()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        print(text.characters.count,string.characters.count,range.length)
        let newLength = text.characters.count + string.characters.count - range.length
        if newLength >= 1{
            delegate?.isAddButtonActive(sender: true)
        } else {
            delegate?.isAddButtonActive(sender: false)
        }
        return newLength <= limitLength
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        inputAccountName.text = "￥"
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        inputAccountName.resignFirstResponder()
        return true
    }
    
    //protocol
    func resignTextField() {
        inputAccountName.resignFirstResponder()
        print("guanbi")
    }
    
    func setInputAlpha(_ sender:CGFloat) {
        inputAccountName.alpha = sender
    }
    
    func setInputClear() {
        inputAccountName.text = ""
    }
    
    func addAccountToRealm() -> Bool{
        guard let text = inputAccountName.text else {
            return true
        }
        if text.characters.count < 1 {
            return true
        }
        
        let account = Account()
        account.id = accounts.count
        account.name = text
        account.createdAt = NSDate()
        account.color = cardColors[pageControll.currentPage]
        
        try! realm.write {
            realm.add(account)
        }
        return false
    }
    
}

protocol AddAccountViewDelegate {
    func resignTextField()
    func setInputAlpha(_ sender:CGFloat)
    func setInputClear()
    func addAccountToRealm() -> Bool
}
