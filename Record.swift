//
//  Record.swift
//  Monthey
//
//  Created by 钟信 on 2016/12/26.
//  Copyright © 2016年 zhongxin. All rights reserved.
//

import Foundation
import RealmSwift

class Record: Object {
    dynamic var createdAt = NSDate()
    dynamic var money = 0.0
    let accountOwners = LinkingObjects(fromType: Account.self, property: "records")
    let monthOwners = LinkingObjects(fromType: Month.self, property: "records")
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
