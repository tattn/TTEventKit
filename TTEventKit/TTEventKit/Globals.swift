//
//  Globals.swift
//  TTEventKit
//
//  Copyright (c) 2014年 tattn. All rights reserved.
//

import Foundation

var nscalendar = NSCalendar.currentCalendar()

extension NSDate {
    func getYearMonthDay() -> NSDateComponents {
        return nscalendar.components([.Year, .Month, .Day], fromDate: self)
    }
}