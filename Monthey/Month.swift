//
//  Month.swift
//  Monthey
//
//  Created by 钟信 on 2016/12/26.
//  Copyright © 2016年 zhongxin. All rights reserved.
//

import Foundation
import RealmSwift

class Month: Object {
    
    dynamic var createdAt = NSDate()
    dynamic var year = 0
    dynamic var month = 0
    var totalAmount: Int {
        return records.sum(ofProperty: "amount") as Int
    }
    let records = List<Record>()

}
