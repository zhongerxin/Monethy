//
//  DateToString.swift
//  MonethyReal
//
//  Created by 钟信 on 2016/8/28.
//  Copyright © 2016年 zhongxin. All rights reserved.
//

import Foundation
struct DateToString {
    var nowDate = NSDate()
    init (nowDate:NSDate) {
        self.nowDate = nowDate
    }
    func dateToString() -> (year:String, month:String) {
        let calendar = NSCalendar.currentCalendar()
        var yearString = (year:"", month:"")
        let dateComponents = calendar.components([NSCalendarUnit.Day,NSCalendarUnit.Month,NSCalendarUnit.Year,NSCalendarUnit.WeekOfYear, NSCalendarUnit.Hour, NSCalendarUnit.Minute, NSCalendarUnit.Second, NSCalendarUnit.Nanosecond], fromDate: nowDate)
        yearString.month = "\(dateComponents.month)月"
        yearString.year = "\(dateComponents.year)年"
        return yearString
    }
    
}
