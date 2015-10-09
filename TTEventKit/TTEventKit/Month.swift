//
//  Date.swift
//  TTEventKit
//
//  Copyright (c) 2014年 tattn. All rights reserved.
//

import Foundation

public class Month {
    public var year: Int
    public var month: Int
    
    public var nsdate: NSDate!
    
    public convenience init() {
        self.init(year: 1970, month: 1)
    }
    
    public init(year: Int, month: Int) {
        self.year = year
        self.month = month
    
        nsdate = toNSdate()
    }
    
    // その月の長さを取得
    public func length() -> Int {
        return nscalendar.rangeOfUnit(.Day, inUnit: .Month, forDate: nsdate).length
    }
    
    public func firstWeekday() -> Weekday {
        let comp = nscalendar.components(.Weekday, fromDate: nsdate)
        return Weekday(rawValue: comp.weekday - 1)!
    }
    
    public func lastWeekday() -> Weekday {
        return firstWeekday() + (length() - 1);
    }
    
    
//=================================
// Utility
//=================================
    
    // 今日の日付を取得
    public class func today() -> (month: Month, day: Int) {
        let comps = nscalendar.components([.Year, .Month, .Day], fromDate: NSDate())
        return (Month(year: comps.year, month: comps.month), comps.day)
    }
    
    // 次の月の日付を取得
    public func next() -> Month {
        var nextYear = year
        var nextMonth = month + 1
        if nextMonth > 12 {
            nextMonth = 1
            nextYear++
        }
        return Month(year: nextYear, month: nextMonth)
    }
    
    // 前の月の日付を取得
    public func prev() -> Month {
        var prevYear = year
        var prevMonth = month - 1
        if prevMonth < 1 {
            prevMonth = 12
            prevYear--
        }
        return Month(year: prevYear, month: prevMonth)
    }
    
    // NSDate型に変換
    private func toNSdate() -> NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        return dateFormatter.dateFromString(String(format: "%04d/%02d/01", year, month))!
    }
    
}

public enum Weekday: Int {
    case Sunday = 0
    case Monday
    case Tuesday
    case Wednesday
    case Thursday
    case Friday
    case Saturday
    
}

public func + (left: Weekday, right: Int) -> Weekday {
    return Weekday(rawValue: (left.rawValue + right) % 7)!
}

