//
//  CalendarDayView.swift
//  SchedulerForStudent
//
//  Copyright (c) 2014年 tattn. All rights reserved.
//

import UIKit
import EventKit

public class CalendarDayView: UIView {
    
    /// 日にち
    var day: Int
    
    /// 曜日
    var weekday: Weekday
    
    /// 日にちのラベル
    var dayLabel: UILabel!
    
    /// 登録されているイベント
    var events = [EKEvent]()
    
    /// 選択されているか否か
    var selected = false
    
    /// 今日か否か
    var isToday = false
    
    /// カレンダー
    var calendar: CalendarView
    
//=================================
// UI
//=================================
    
    required public init?(coder aDecoder: NSCoder) {
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
        
        let frameLine = UIBezierPath(rect: rect)
        
        // 選択時に強調させる
        if selected {
            calendar.config.selectDayBackgroundColor.setFill()
            frameLine.fill()
        }
        
        let line = UIBezierPath()
        
        // 月の区切り線の描画
        drawSeparator(line, rect: rect)
        
        // 枠の描画
        drawFrame(frameLine)
        
        // 予定の描画
        drawPlan(rect)
    }
    
    // 月の区切り線の描画
    private func drawSeparator(line: UIBezierPath, rect: CGRect) {
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
    }
    
    // 枠の描画
    private func drawFrame(rectPath: UIBezierPath) {
        if isToday {
            // 今日であれば強調させる
            calendar.config.todayColor.setStroke()
            calendar.config.todayColor.setFill()
            
            let header = UIBezierPath(rect: dayLabel.frame)
            header.fill()
            
            rectPath.lineWidth = 3
            
            dayLabel.textColor = UIColor.whiteColor()
            rectPath.stroke()
        }
        else {
            UIColor.grayColor().setStroke()
            
            rectPath.lineWidth = 0.3
        }
        
        rectPath.stroke()
    }
    
    // 予定の描画
    private func drawPlan(rect: CGRect) {
        
        let minX = rect.minX + 2
        let minY = rect.minY + dayLabel.frame.height + 2
        
        let attributes = [NSFontAttributeName: UIFont.systemFontOfSize(10)]
        
        var y = minY
        for i in 0..<events.count {
            let str = events[i].title as NSString
            let pt = CGPointMake(minX, y)
            str.drawAtPoint(pt, withAttributes: attributes)
            
            let size = str.sizeWithAttributes(attributes)
            y += size.height
        }
    }
    
    // 選択する
    func select() {
        dayLabel.textColor = calendar.config.selectDayTextColor
        calendar.daySelected(self)
        selected = true
        
        setNeedsDisplay()
    }
    
    // 選択を解除する
    func unselect() {
        selected = false
        dayLabel.textColor = calendar.config.defaultDayTextColor
        
        setNeedsDisplay()
    }
    
    // 今日の日付として設定する
    func setAsToday() {
        isToday = true
    }
    
    
    // イベントを追加する
    func addEvent(event: EKEvent) {
        events.append(event)
    }
    
//=================================
// Touches
//=================================
    override public func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        
        let monthView = superview as! CalendarMonthView
        
        print("\(monthView.month.year) \(monthView.month.month) \(dayLabel.text)")
        
        select()
    }

}
