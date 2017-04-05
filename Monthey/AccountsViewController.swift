//
//  AccountsViewController.swift
//  Monthey
//
//  Created by 钟信 on 2016/12/16.
//  Copyright © 2016年 zhongxin. All rights reserved.
//

import UIKit
import pop
import RealmSwift

class AccountsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,AccountViewDelegate {
    //delagate
    var delegate:AddAccountViewDelegate?
    
    //ui
    @IBOutlet weak var addAccountButton: UIButton!
    @IBOutlet weak var addAccountBg: UIView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var maskBg: UIView!
    @IBOutlet weak var accountsTableView: UITableView!
    
    //layout
    @IBOutlet weak var addAccountBgWidth: NSLayoutConstraint!
    @IBOutlet weak var addAccountBgHeight: NSLayoutConstraint!
    @IBOutlet weak var addAccountBgBottom: NSLayoutConstraint!
    @IBOutlet weak var addAccountButtonBottom: NSLayoutConstraint!
    
    //var
    var buttonBottom:CGFloat!
    var buttonHeight:CGFloat!
    var accounts = realm.objects(Account.self)
    var activeAccounts = realm.objects(Account.self).filter("isDelete = false")
    var notificationToken: NotificationToken? = nil
    var deleteAccountsCount:Int!
    //let
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deleteAccountsCount = accounts.count - activeAccounts.count
        //ui
        setAddAccount()
        //layout
        buttonHeight = addAccountBgHeight.constant
        buttonBottom = addAccountBgBottom.constant
        //通知
        NotificationCenter.default.addObserver(self,selector: #selector(self.keyboardWillChange(_:)),name: .UIKeyboardWillChangeFrame, object: nil)
        
        notificationToken = activeAccounts.addNotificationBlock { changes in
            switch changes {
            case .initial( _):
                break
            case .update(_ , let deletions, let insertions, let modifications):
                self.accountsTableView.beginUpdates()
<<<<<<< HEAD
                print(self.activeAccounts)
=======
>>>>>>> origin/master
                self.accountsTableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                print(deletions,insertions,modifications)
                self.accountsTableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                self.accountsTableView.endUpdates()
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
    
    //tableview
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return activeAccounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cardCell", for: indexPath) as! CardsTableViewCell
        let account = activeAccounts[indexPath.row]
        switch account.color {
        case "orange":
            cell.cardsColorBgImage.image = #imageLiteral(resourceName: "orange_gradient_bg")
        case "green":
            cell.cardsColorBgImage.image = #imageLiteral(resourceName: "green_gradient_bg")
        default:
            cell.cardsColorBgImage.image = #imageLiteral(resourceName: "blue_gradient_bg")
        }
        cell.accountNameLabel.text = account.name
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "删除") { (deleteAction, indexPath) -> Void in
            //Deletion will go here
            print("delete")
            let account = self.activeAccounts[indexPath.row]
            try! realm.write{
                account.isDelete = true
            }
        }
        let editAction = UITableViewRowAction(style: .normal, title: "编辑") { (editAction, indexPath) -> Void in
            print("edit")
        }
        
        return [deleteAction, editAction]
    }
    
    //set
    func setAddAccount() {
        addAccountButton.layer.borderColor = UIColor.clear.cgColor
        addAccountBg.layer.cornerRadius = 26
        addAccountBg.layer.shadowColor = UIColor(colorLiteralRed: 1/255, green: 40/255, blue: 98/255, alpha: 39/100).cgColor
        addAccountBg.layer.shadowOffset = CGSize(width: 0, height: 4)
        addAccountBg.layer.shadowRadius = 10
        addAccountBg.layer.shadowOpacity = 1
        cardView.alpha = 0.01
        maskBg.alpha = 0
    }
    
    //tap
    @IBAction func tapAddButton(_ sender: Any) {
        let  a = sender as! UIButton
        switch a.state.rawValue {
        case 1:
            coreAnimation(true)
            popAnimation(true)
        default:
            let isInputEmpty = delegate?.addAccountToRealm()
            if isInputEmpty! {
                return
            } else {
                delegate?.resignTextField()
                coreAnimation(false)
                popAnimation(false)
                delegate?.setInputClear()
            }
        }
    }
    
    func keyboardWillChange(_ notification: NSNotification) {
        if let userInfo = notification.userInfo,
            let value = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue,
            let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double,
            let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? UInt {
            let frame = value.cgRectValue
            var intersection = frame.intersection(self.view.frame)
            //当键盘消失，让view回归原始位置
            if intersection.height == 0.0 {
                intersection = CGRect(x: intersection.origin.x, y: intersection.origin.y, width: intersection.width, height: self.view.center.y - 500/2 - 10)
            }
            addAccountBgBottom.constant = intersection.height + 10
            UIView.animate(withDuration: duration, delay: 0.0,
                                       options: UIViewAnimationOptions(rawValue: curve), animations: {
                                        _ in
                                        //改变下约束
                                        self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    
    //animation
    func coreAnimation(_ sender: Bool) {
        let cardHeight:CGFloat = 500
        var scale:CGFloat!
        var alpha:CGFloat!
        var buttonAlpha:CGFloat!
        
        switch sender {
        case true:
            scale = 1
            alpha = 0.01
            buttonAlpha = 0.5
            self.addAccountBgWidth.constant = self.view.frame.width - 20
            self.addAccountBgHeight.constant = cardHeight
            self.addAccountBgBottom.constant = self.view.center.y - cardHeight/2
            self.addAccountButtonBottom.constant = 25
            
        default:
            scale = 0.01
            alpha = 1
            buttonAlpha = 1
            self.addAccountBgWidth.constant = buttonHeight
            self.addAccountBgHeight.constant = buttonHeight
            self.addAccountBgBottom.constant = buttonBottom
            self.addAccountButtonBottom.constant = 0
        }
        UIView.animate(withDuration: 0.3, delay: 0, options:.curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.addAccountButton.isSelected = sender
            self.cardView.transform = CGAffineTransform(scaleX: scale, y: scale)
            self.cardView.alpha = scale
            self.addAccountButton.alpha = buttonAlpha
            self.navigationController?.navigationBar.alpha = alpha
        }, completion: {_ in
            self.delegate?.setInputAlpha(scale)
        })
    }
    
    func popAnimation(_ sender:Bool) {
        var toColor:CGColor!
        var toRadius:Int!
        var toAlpha:CGFloat!
        switch sender {
        case true:
            toColor = UIColor.white.cgColor
            toRadius = 4
            toAlpha = 0.8
        default:
            toColor = UIColor.clear.cgColor
            toRadius = 26
            toAlpha = 0.0
        }
        
        let bordedrAnimation = POPBasicAnimation(propertyNamed: kPOPLayerBorderColor)
        bordedrAnimation?.toValue = toColor
        bordedrAnimation?.duration = 0.3
        bordedrAnimation?.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        addAccountButton.layer.pop_add(bordedrAnimation, forKey: "borderColor")
        
        let cornerAnimation = POPBasicAnimation(propertyNamed: kPOPLayerCornerRadius)
        cornerAnimation?.toValue = toRadius
        cornerAnimation?.duration = 0.3
        cornerAnimation?.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        addAccountBg.layer.pop_add(cornerAnimation, forKey: "cornerRadius")
        
        let alphaAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        alphaAnimation?.toValue = toAlpha
        alphaAnimation?.duration = 0.3
        alphaAnimation?.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        maskBg.pop_add(alphaAnimation, forKey: "alpha")
    }
    
    //segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addAccount"  {
            let desinationController = segue.destination as! AddAccountViewController
            delegate = desinationController
            desinationController.delegate = self
        }
    }
    
    //protocol
    func cancelCard() {
        coreAnimation(false)
        popAnimation(false)
        delegate?.resignTextField()
    }
    func isAddButtonActive(sender:Bool) {
        if sender {
            addAccountButton.alpha = 1
        } else {
            addAccountButton.alpha = 0.5
        }
    }
    
}
protocol AccountViewDelegate {
    func cancelCard()
    func isAddButtonActive(sender:Bool)
}
