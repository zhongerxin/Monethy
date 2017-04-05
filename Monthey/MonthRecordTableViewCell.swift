//
//  MonthRecordTableViewCell.swift
//  Monthey
//
//  Created by 钟信 on 2017/2/23.
//  Copyright © 2017年 zhongxin. All rights reserved.
//

import UIKit

class MonthRecordTableViewCell: UITableViewCell {
    @IBOutlet weak var moneyAmountNumber: UILabel!
    @IBOutlet weak var monthNumber: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
