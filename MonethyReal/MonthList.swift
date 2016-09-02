//
//  MonthList.swift
//  MonethyReal
//
//  Created by 钟信 on 2016/8/28.
//  Copyright © 2016年 zhongxin. All rights reserved.
//

import Foundation
import RealmSwift

class MonthList: Object {
    dynamic var createdDate = NSDate()
    dynamic var totalMoney = 0
    var accounts = List<Accounts>()
}
