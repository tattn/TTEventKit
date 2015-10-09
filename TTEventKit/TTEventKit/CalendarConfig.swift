//
//  CalendarConfig.swift
//  TTEventKit
//
//  Copyright (c) 2014年 tattn. All rights reserved.
//

import Foundation

public class CalendarConfig {
    
    // 非フォーカス時のカレンダーの背景色
    public var defaultBackgroundColor = UIColor.groupTableViewBackgroundColor()
    
    // フォーカス時のカレンダーの背景色
    public var currentBackgroundColor = UIColor.whiteColor()
    
    
    
    
    // 日を選択した時の背景色
    public var selectDayBackgroundColor = UIColor(
        red: 0.9137254902, green: 0.9490196078, blue: 0.9764705882, alpha: 1.0)
    
    // 日を選択した時の文字色
    public var selectDayTextColor = UIColor.blackColor()
    
    // 通常時の日数の文字色
    public var defaultDayTextColor = UIColor.blackColor()
    
    // 今日の日付の強調色
    public var todayColor = UIColor.fromHex("#E88D67")
    
    
    
    // 曜日の表記
    public var weekNotation = ["日", "月", "火", "水", "木", "金", "土"]
    
    // 土曜日の文字色
    public var saturdayColor = UIColor.blueColor()
    
    // 日曜日の文字色
    public var sundayColor = UIColor.redColor()
    
    // 休日の文字色
    public var holidayColor = UIColor.redColor()
}

extension UIColor {
    class func fromHex (var hexStr : NSString, alpha: CGFloat = 1.0) -> UIColor {
        hexStr = hexStr.stringByReplacingOccurrencesOfString("#", withString: "")
        let scanner = NSScanner(string: hexStr as String)
        var color: UInt32 = 0
        if scanner.scanHexInt(&color) {
            let r = CGFloat((color & 0xFF0000) >> 16) / 255.0
            let g = CGFloat((color & 0x00FF00) >> 8) / 255.0
            let b = CGFloat(color & 0x0000FF) / 255.0
            return UIColor(red: r, green: g, blue: b, alpha: alpha)
        } else {
            print("invalid hex string")
            return UIColor.whiteColor();
        }
    }
}
