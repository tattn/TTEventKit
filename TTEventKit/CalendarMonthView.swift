//
//  CalendarMonthView.swift
//  SchedulerForStudent
//
//  Copyright (c) 2014年 tanakasan2525. All rights reserved.
//

import UIKit

public class CalendarMonthView: UIView {
    
    // セルのサイズ
    var dayWidth: CGFloat
    var dayHeight: CGFloat
    
    // 行列
    var rows: Int = 0
    var columns: Int = 7
    
    // 年月
    var year: Int = 1970
    var month: Int = 1
    
    // 何日まであるか
    var length: Int = 0
    
    // 最初の日は何曜日か(1:日、2:月、...)
    var firstWeekday: Int = 0
    
    // 最後の日は何曜日か(1:日、2:月、...)
    var lastWeekday: Int = 0

    required public init(coder aDecoder: NSCoder) {
        fatalError("CalendarMonthView: init(coder)")
    }
    
    init(frame: CGRect, year: Int, month: Int) {
        self.dayWidth = frame.width / 7
        self.dayHeight = dayWidth
        
        super.init(frame: frame)
        
//        layer.borderColor = UIColor.yellowColor().CGColor
//        layer.borderWidth = 2.0
        
        layoutMargins = UIEdgeInsetsZero
        preservesSuperviewLayoutMargins = false
        
        // 背景色を透明に
        backgroundColor = UIColor.clearColor()
        
        self.setup(year, month: month)
    }
    
    func relayout() {
        self.dayWidth = frame.width / 7
        self.dayHeight = dayWidth
        
        self.setup(self.year, month: self.month)
    }
    
    func setup(year: Int, month: Int) {
        // 初期化
        for v in self.subviews as [UIView] {
//            if v.isKindOfClass(CalendarDayView) {
                v.removeFromSuperview()
//            }
        }
        
        self.year = year
        self.month = month
        
        // 指定した年月の最初の日を取得
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        var date = dateFormatter.dateFromString(String(format: "%04d/%02d/01", year, month))
        
        // カレンダーから曜日の情報を取得
        let calendar = NSCalendar.currentCalendar()
        let comp = calendar.components(.WeekdayCalendarUnit, fromDate: date!)
        
        // 最初の日の曜日とその月が何日まであるかを取得
        length = calendar.rangeOfUnit(.DayCalendarUnit, inUnit: .MonthCalendarUnit, forDate: date!).length
        firstWeekday = comp.weekday
        lastWeekday = (firstWeekday + length - 1) % 7
        if lastWeekday == 0 {
            lastWeekday = 7
        }
        
        // 行数の取得
        rows = Int(ceil(Float(length + firstWeekday - 1) / Float(columns)))
        
        for i in 1...length {
            let week = firstWeekday + i - 2      // 曜日は[日:1, 月:2, ...]と表現されているので0からに直す
            let x = CGFloat(week % 7) * self.dayWidth
            let y = CGFloat(week / 7) * self.dayHeight
            
            let frame = CGRectMake(x, y, self.dayWidth, self.dayHeight)
            let dayView = CalendarDayView(frame: frame, day: i, weekday: week % 7 + 1)
            
            self.addSubview(dayView)
        }
        
        // カレンダーサイズの調整
        sizeToFit()
        
        // drawRectでの再描画
        setNeedsDisplay()
    }
    
    override public func drawRect(rect: CGRect) {
        
//        CGContextSetRGBFillColor(context, 0.5, 0.5, 0.8, 0.9)
//        CGContextFillRect(context, rect)
        
        var line = UIBezierPath()
        line.lineWidth = 0.3
        
        UIColor.grayColor().setStroke()
        
        // 横線
        for y in 1..<rows {
            line.moveToPoint(CGPointMake(rect.minX, dayHeight * CGFloat(y)))
            line.addLineToPoint(CGPointMake(rect.width, dayHeight * CGFloat(y)))
        }
        
        // 縦線
       	for x in 0...(columns + 1) {
            line.moveToPoint(CGPointMake(dayWidth * CGFloat(x), rect.minY))
            line.addLineToPoint(CGPointMake(dayWidth * CGFloat(x), rect.height))
        }
        
        line.stroke()
    }
    
    override public func sizeThatFits(size: CGSize) -> CGSize {
        return CGSizeMake(dayWidth * CGFloat(columns), dayHeight * CGFloat(rows))
    }
    
    func viewHeight() -> CGFloat {
        return dayHeight * CGFloat(rows)
    }
    
    
//=================================
// Config
//=================================
//    public override var backgroundColor: UIColor? = UIColor.clearColor() {
//        didSet {
//            for v in subviews as [UIView] {
//                v.backgroundColor = oldValue
//            }
//        }
//    }
    
    
}
