//
//  AccountRecordCell.swift
//  Monthey
//
//  Created by 钟信 on 2017/2/27.
//  Copyright © 2017年 zhongxin. All rights reserved.
//

import UIKit

class AccountRecordCell: UITableViewCell {

    @IBOutlet weak var accountName: UILabel!
    @IBOutlet weak var monthAmount: UILabel!
    @IBOutlet weak var dashLine: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
