//
//  Accounts.swift
//  MonethyReal
//
//  Created by 钟信 on 2016/8/28.
//  Copyright © 2016年 zhongxin. All rights reserved.
//

import Foundation
import RealmSwift

class Accounts: Object {
    
    dynamic var accountName = ""
    dynamic var accountMoney = 0
    dynamic var createDate = NSDate()
}
