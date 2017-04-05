//
//  DateToInt.swift
//  Monthey
//
//  Created by 钟信 on 2016/12/29.
//  Copyright © 2016年 zhongxin. All rights reserved.
//

import Foundation
struct DateToString {
    var currentDate = Date()
    init (currentDate:Date) {
        self.currentDate = currentDate
    }
    
    func dateToString() -> (year:Int, month:Int, day:Int) {
        
        let calendar = Calendar.current
        var yearMonthDay = (year:0, month:0,day:0)
        let dateComponents = calendar.dateComponents([Calendar.Component.era, Calendar.Component.year,    Calendar.Component.month, Calendar.Component.day, Calendar.Component.hour, Calendar.Component.minute,   Calendar.Component.second], from: currentDate)
        guard let month = dateComponents.month, let year = dateComponents.year, let day = dateComponents.day
            else {
            fatalError("日期解包错误")
        }
        
        yearMonthDay.month = month
        yearMonthDay.year = year
        yearMonthDay.day = day
        return yearMonthDay
    }
    
}
