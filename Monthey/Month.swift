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
    let records = List<Record>()
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
