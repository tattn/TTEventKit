//
//  CalendarMonthView.swift
//  SchedulerForStudent
//
//  Copyright (c) 2014年 tattn. All rights reserved.
//

import UIKit

public class CalendarMonthView: UIView {
    
    /// セルのサイズ
    var dayWidth: CGFloat = 0
    var dayHeight: CGFloat = 0
    
    /// 行
    var rows: Int = 0
    
    /// このビューが表示している月
    var month: Month!
    
    /// 何日まであるか
    var length: Int = 0
    
    /// 最初と最後の曜日
    var firstWeekday:Weekday = .Sunday
    var lastWeekday:Weekday = .Sunday
    
    /// 日のビュー
    var dayViews = [CalendarDayView]()
    
    /// カレンダー
    var calendar: CalendarView!
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("CalendarMonthView: init(coder)")
    }
    
    init(frame: CGRect, month: Month) {
        super.init(frame: frame)
        
        self.month = month
    }
    
    func relayout() {
        dayWidth = frame.width / 7
        dayHeight = superview!.frame.height / 6
        
        setup(month)
    }
    
    func setup(month: Month) {
        // 初期化
        for v in subviews as [UIView] {
            v.removeFromSuperview()
        }
        dayViews.removeAll(keepCapacity: true)
        
        self.month = month
        
        // 最初の日の曜日とその月が何日まであるかを取得
        length = month.length()
        firstWeekday = month.firstWeekday()
        lastWeekday = month.lastWeekday()
        
        // 行数の取得
        rows = Int(ceil(Float(length + firstWeekday.rawValue) / 7))
        
        // 日のビューを生成
        for i in 0..<length {
            let week = firstWeekday.rawValue + i
            let x = CGFloat(week % 7) * dayWidth
            let y = CGFloat(week / 7) * dayHeight
            
            let frame = CGRectMake(x, y, dayWidth, dayHeight)
            let dayView = CalendarDayView(frame: frame, day: i + 1, weekday: firstWeekday + i, calendar: calendar)
            
            dayViews.append(dayView)
            self.addSubview(dayView)
        }
        
        // 今日の日付があれば強調
        if month.month == calendar.today.month.month && month.year == calendar.today.month.year {
            dayViews[calendar.today.day - 1].setAsToday()
        }
        
        // 予定を取得して追加
        if let ev = EventStore.getEvents(month) {
            for e in ev {
                let date = e.startDate.getYearMonthDay()
                dayViews[date.day - 1].addEvent(e)
            }
        }
        
        
        // カレンダーサイズの調整
        sizeToFit()
        
        // drawRectでの再描画
        setNeedsDisplay()
    }
    
    override public func sizeThatFits(size: CGSize) -> CGSize {
        return CGSizeMake(dayWidth * 7, dayHeight * CGFloat(rows))
    }
    
    func viewHeight() -> CGFloat {
        return dayHeight * CGFloat(rows)
    }
    
    // サブビューのみにタッチイベントを伝える
    public override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, withEvent: event)
        if view == self {
            return nil
        }
        return view
    }
    
    
//=================================
// Config
//=================================
    
    public override var backgroundColor: UIColor? {
        didSet {
            for v in subviews as [UIView] {
                v.backgroundColor = backgroundColor
            }
            
            super.backgroundColor = UIColor.clearColor()
        }
    }
    
    
}
