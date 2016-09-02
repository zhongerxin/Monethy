//
//  PickerViewCell.swift
//  MonethyReal
//
//  Created by 钟信 on 2016/8/29.
//  Copyright © 2016年 zhongxin. All rights reserved.
//

import UIKit

class PickerViewCell: UITableViewCell {

    @IBOutlet weak var pickerButton: UIDatePicker!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        pickerButton.locale = NSLocale(localeIdentifier: "zh_CN")
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func getDate() -> NSDate {
        var date = NSDate()
        date = pickerButton.date
        return date
    }
}
