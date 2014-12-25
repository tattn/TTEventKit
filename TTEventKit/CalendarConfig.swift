//
//  CalendarConfig.swift
//  TTEventKit
//
//  Created by Tanaka Tatsuya on 2014/12/26.
//  Copyright (c) 2014年 tanakasan2525. All rights reserved.
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
    
    // 曜日の表記
    public var weekNotation = ["日", "月", "火", "水", "木", "金", "土"]
    
    // 土曜日の文字色
    public var saturdayColor = UIColor.blueColor()
    
    // 日曜日の文字色
    public var sundayColor = UIColor.redColor()
}
