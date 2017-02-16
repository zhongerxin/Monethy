//
//  RecordsTableViewCell.swift
//  Monthey
//
//  Created by 钟信 on 2017/1/23.
//  Copyright © 2017年 zhongxin. All rights reserved.
//

import UIKit

class RecordsTableViewCell: UITableViewCell,RecordsTableViewDelegate,UITextFieldDelegate {

    @IBOutlet weak var moneyIconLabel: UILabel!
    @IBOutlet weak var accountNameLabel: UILabel!
    @IBOutlet weak var inputAmountField: UITextField!
    @IBOutlet weak var addOrMinusButton: UIButton!
   
    var id:Int!
    
    let limitLength = 15
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setInputAmountField()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    func setInputAmountField() {
        inputAmountField.isHidden = false
        inputAmountField.attributedPlaceholder = NSAttributedString(string: "请输入金额", attributes:[NSForegroundColorAttributeName: UIColor(colorLiteralRed: 1, green: 1, blue: 1, alpha: 60/100),NSFontAttributeName:UIFont.systemFont(ofSize: 16)])
        inputAmountField.delegate = self
        inputAmountField.leftViewMode = UITextFieldViewMode.always
        isShowMoneyIcon(sender: false)
    }
    func isShowMoneyIcon(sender:Bool) {
        switch sender {
        case true:
            let spacerView = UIView(frame:CGRect(x:0, y:0, width:16, height:10))
            moneyIconLabel.isHidden = false
            inputAmountField.leftView = spacerView
        default:
            let spacerView = UIView(frame:CGRect(x:0, y:0, width:0, height:10))
            moneyIconLabel.isHidden = true
            inputAmountField.leftView = spacerView
        }
    }
    
    func setCellToInsertRow() {
        print("gggg")
        accountNameLabel.alpha = 1
        accountNameLabel.text = "点击加号增加记录"
        inputAmountField.isHidden = true
        addOrMinusButton.isSelected = true
    }
    
    func setDefaultRow() {
        accountNameLabel.alpha = 0.9
        addOrMinusButton.isSelected = false
        inputAmountField.isHidden = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        inputAmountField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let invalidCharacters = CharacterSet(charactersIn: "0123456789.").inverted
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        if newLength >= 1 {
            isShowMoneyIcon(sender: true)
        } else {
            isShowMoneyIcon(sender: false)
        }
        return string.rangeOfCharacter(from: invalidCharacters, options: [], range: string.startIndex ..< string.endIndex) == nil && newLength <= limitLength
    }

}
protocol RecordsTableViewDelegate {
    func setCellToInsertRow()
}

