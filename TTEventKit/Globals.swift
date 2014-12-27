//
//  Globals.swift
//  TTEventKit
//
//  Copyright (c) 2014年 tanakasan2525. All rights reserved.
//

import Foundation

var nscalendar = NSCalendar.currentCalendar()

extension NSDate {
    func getYearMonthDay() -> NSDateComponents {
        let flags: NSCalendarUnit =
                NSCalendarUnit.YearCalendarUnit |
                NSCalendarUnit.MonthCalendarUnit |
                NSCalendarUnit.DayCalendarUnit
        return nscalendar.components(flags, fromDate: self)
    }
}