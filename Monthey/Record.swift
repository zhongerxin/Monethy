//
//  Record.swift
//  Monthey
//
//  Created by 钟信 on 2016/12/28.
//  Copyright © 2016年 zhongxin. All rights reserved.
//

import Foundation
import RealmSwift

class Record: Object {
    
    dynamic var createdAt = NSDate()
    dynamic var amount = 0.0
    let accountOwners = LinkingObjects(fromType: Account.self, property: "records")
    let monthOwners = LinkingObjects(fromType: Month.self, property: "records")
    
}
