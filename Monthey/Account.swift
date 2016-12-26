//
//  Account.swift
//  Monthey
//
//  Created by 钟信 on 2016/12/26.
//  Copyright © 2016年 zhongxin. All rights reserved.
//

import Foundation
import RealmSwift

class Account: Object {
    dynamic var id = 0
    dynamic var name = ""
    dynamic var createdAt = NSDate()
    dynamic var isDelete = false
    let records = List<Record>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func indexedProperties() -> [String] {
        return ["name"]
    }
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
