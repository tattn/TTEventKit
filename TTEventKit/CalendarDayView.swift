//
//  CalendarDayView.swift
//  SchedulerForStudent
//
//  Copyright (c) 2014年 tanakasan2525. All rights reserved.
//

import UIKit

public class CalendarDayView: UIView {
    
    // 日にち
    var day: Int
    
    // 曜日
    var weekday: Weekday
    
    // 日にちのラベル
    var dayLabel: UILabel!
    
    // 選択されているか否か
    var selected: Bool = false
    
    // カレンダー
    var calendar: CalendarView
    
//=================================
// UI
//=================================
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("DayView: Init(coder)")
    }

    init(frame: CGRect, day: Int, weekday: Weekday, calendar: CalendarView) {
        self.day = day
        self.weekday = weekday
        self.calendar = calendar
        
        super.init(frame: frame)
        
        dayLabel = UILabel()
        dayLabel.text = String(format: "%02d", day)
        dayLabel.textAlignment = NSTextAlignment.Center
        dayLabel.font = UIFont.systemFontOfSize(11)
        dayLabel.sizeToFit()
        dayLabel.frame.size.width = frame.width
        
        // 土日の色を変える
        if weekday == .Sunday {
            dayLabel.textColor = calendar.config.sundayColor
        }
        else if weekday == .Saturday {
            dayLabel.textColor = calendar.config.saturdayColor
        }
        
        self.addSubview(dayLabel)
    }
    
    override public func drawRect(rect: CGRect) {
        
        var frameLine = UIBezierPath(rect: rect)
        
        // 選択時に強調させる
        if selected {
            calendar.config.selectDayBackgroundColor.setFill()
            frameLine.fill()
//            let frame = CGRectMake(rect.minX, rect.minY, rect.width, dayLabel.frame.height)
//            var roundRect = UIBezierPath(roundedRect: frame, cornerRadius: 4)
//            
//            UIColor.blueColor().setFill()
//            roundRect.fill()
        }
        
        var line = UIBezierPath()
        
        // 月の区切り線の描画
        if day <= 7 {
            line.lineWidth = 3
            
            UIColor.blackColor().setStroke()
            
            line.moveToPoint(CGPointMake(rect.minX, rect.minY))
            line.addLineToPoint(CGPointMake(rect.width, rect.minY))
            
            if day == 1 && weekday != .Sunday {
                line.moveToPoint(CGPointMake(rect.minX, rect.minY))
                line.addLineToPoint(CGPointMake(rect.minX, rect.height))
            }
            
            line.stroke()
        }
        
        // 枠の描画
        UIColor.grayColor().setStroke()
        
        frameLine.lineWidth = 0.3
        frameLine.stroke()
    }
    
    func select() {
        selected = true
        dayLabel.textColor = calendar.config.selectDayTextColor
        calendar.daySelected(self)
        
        setNeedsDisplay()
    }
    
    func unselect() {
        selected = false
        dayLabel.textColor = calendar.config.defaultDayTextColor
        
        setNeedsDisplay()
    }
    
    
//=================================
// Touches
//=================================
    override public func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        let monthView = superview as CalendarMonthView
        
        println("\(monthView.month.year) \(monthView.month.month) \(dayLabel.text)")
        
        select()
    }

}
