//
//  RecordsTableViewCell.swift
//  Monthey
//
//  Created by 钟信 on 2017/1/23.
//  Copyright © 2017年 zhongxin. All rights reserved.
//

import UIKit

class RecordsTableViewCell: UITableViewCell,RecordsTableViewDelegate,UITextFieldDelegate {

    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var accountNameLabel: UILabel!
    @IBOutlet weak var inputAmountField: UITextField!
    @IBOutlet weak var addOrMinusButton: UIButton!
   
    var id:Int!
    var delegate:AddRecordViewDelegate?
    
    let limitLength = 15
    
    override func awakeFromNib() {
        super.awakeFromNib()
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
            iconLabel.isHidden = false
            inputAmountField.leftView = spacerView
        default:
            let spacerView = UIView(frame:CGRect(x:0, y:0, width:0, height:10))
            inputAmountField.leftView = spacerView
            iconLabel.isHidden = true
        }
    }
    
    func setCellToInsertRow() {
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
        guard let text = textField.text else { return true }
        inputAmountField.attributedText = NSAttributedString(string: "\(text)", attributes:[NSKernAttributeName:1.5])
        let newLength = text.characters.count + string.characters.count - range.length
        if newLength >= 1 {
            isShowMoneyIcon(sender: true)
        } else {
            
            isShowMoneyIcon(sender: false)
        }
        
        switch string {
        case "0","1","2","3","4","5","6","7","8","9":
            return true && newLength <= limitLength
        case ".":
            let array = text
            var decimalCount = 0
            for character in array.characters {
                if character == "." {
                    decimalCount += 1
                }
            }
            if array.characters.count == 0 {
                return false
            }
            if decimalCount == 1 {
                return false
            } else {
                return true && newLength <= limitLength
            }
        case "":
            return true
        default:
            return false
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.setCellToIndexPath(cell: self)
    }
}
protocol RecordsTableViewDelegate {
    func setCellToInsertRow()
    func setDefaultRow()
    func setInputAmountField()
}

