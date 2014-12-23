//
//  CalendarDayView.swift
//  SchedulerForStudent
//
//  Copyright (c) 2014年 tanakasan2525. All rights reserved.
//

import UIKit

class CalendarDayView: UIView {
    
    // 日にち
    var day: Int = 0
    
    // 曜日（1: 日, 2: 月, ..., 7: 土）
    var weekday: Int = 0
    
    // 日にちのラベル
    var dayLabel: UILabel!
    
//=================================
// UI
//=================================
    
    required init(coder aDecoder: NSCoder) {
        fatalError("DayView: Init(coder)")
    }

    init(frame: CGRect, day: Int, weekday: Int) {
        super.init(frame: frame)
        
        self.day = day
        self.weekday = weekday
        
        // 背景色を透明に
        backgroundColor = UIColor.clearColor()
        
        preservesSuperviewLayoutMargins = false
        
        dayLabel = UILabel(frame: CGRectMake(0, 0, frame.width, 20))
        dayLabel.text = String(format: "%02d", day)
        dayLabel.textAlignment = NSTextAlignment.Center
        
        if weekday == 1 {
            // 日曜日は赤色
            dayLabel.textColor = UIColor.redColor()
        }
        else if weekday == 7 {
            // 土曜日は青色
            dayLabel.textColor = UIColor.blueColor()
        }
        
        self.addSubview(dayLabel)
    }
    
    func check() {
        
    }
    
    override func drawRect(rect: CGRect) {
        
        var line = UIBezierPath()
        
        if day <= 7 {
            line.lineWidth = 3
            
            UIColor.blackColor().setStroke()
            
            line.moveToPoint(CGPointMake(rect.minX, rect.minY))
            line.addLineToPoint(CGPointMake(rect.width, rect.minY))
            
            if day == 1 && weekday != 1 {
                line.moveToPoint(CGPointMake(rect.minX, rect.minY))
                line.addLineToPoint(CGPointMake(rect.minX, rect.height))
            }
            
            line.stroke()
        }
    }
    
    
//=================================
// Touches
//=================================
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        let monthView = self.superview as CalendarMonthView
        println("\(monthView.year) \(monthView.month) \(dayLabel.text)")
    }

}
