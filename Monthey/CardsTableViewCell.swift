//
//  CardsTableViewCell.swift
//  Monthey
//
//  Created by 钟信 on 2017/2/1.
//  Copyright © 2017年 zhongxin. All rights reserved.
//

import UIKit

class CardsTableViewCell: UITableViewCell {
    @IBOutlet weak var cardsColorBgImage: UIImageView!
    @IBOutlet weak var accountNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
