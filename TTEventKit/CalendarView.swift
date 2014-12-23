//
//  CalendarView.swift
//  SchedulerForStudent
//
//  Copyright (c) 2014年 tanakasan2525. All rights reserved.
//

import UIKit

@IBDesignable public class CalendarView: UIView, UIScrollViewDelegate {
    
    // 現在表示している日付
    public var currentYear: Int = 1970
    public var currentMonth: Int = 1
    public var currentDay: Int = 1
    
    // 各要素の表示領域
    var weekdayFrame: CGRect!
    var calendarFrame: CGRect!
    
    // 曜日を表示するラベル
    var weekdayLabels = [UILabel]()
    
    // カレンダーのビュー
    var scrollView: UIScrollView!
    var monthViews = [CalendarMonthView]()
    
    // デリゲート
    @IBInspectable public var delegate: CalendarDelegate?

//=================================
// UI
//=================================
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        readyCalendar()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        readyCalendar()
    }
    
    // カレンダーの部品を生成します。
    func readyCalendar() {
        // 背景色
        backgroundColor = UIColor.whiteColor()
        
        // 曜日の表示
        let weekStrs = ["日", "月", "火", "水", "木", "金", "土"]
        for str in weekStrs {
            var label = makeLabel(str, frame: self.frame)
            addSubview(label)
            weekdayLabels.append(label)
        }
        // 土日の色を変える
        weekdayLabels[0].textColor = UIColor.redColor()
        weekdayLabels[6].textColor = UIColor.blueColor()
        
        // 現在の日付を取得
        let date = getCurrentDate()
        currentYear = date.year
        currentMonth = date.month
        
        // 先月のカレンダーを生成
        var prevDate = getPrevYearMonth()
        monthViews.append(CalendarMonthView(frame: frame, year: prevDate.year, month: prevDate.month))
        
        // 今月のカレンダーを生成
        monthViews.append(CalendarMonthView(frame: frame, year: currentYear, month: currentMonth))
        
        // 翌月のカレンダーを生成
        var nextDate = getNextYearMonth()
        monthViews.append(CalendarMonthView(frame: frame, year: nextDate.year, month: nextDate.month))
        
        // カレンダーの表示
        scrollView = makeScrollView()
        for v in monthViews {
            scrollView.addSubview(v)
        }
        addSubview(scrollView)
        
        layoutSubviews()
        
        delegate?.changedMonth(currentYear, month: currentMonth)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        weekdayFrame = CGRectMake(0, 0, frame.width, 20)
        calendarFrame = CGRectMake(0, 40, frame.width, frame.height - 60)
        
        // 曜日の調整
        let y = self.weekdayFrame.minY
        let w = self.weekdayFrame.width / 7
        for i in 0..<self.weekdayLabels.count {
            self.weekdayLabels[i].frame = CGRectMake(CGFloat(i) * w, y, w, w)
        }
        
        // カレンダーを調節
        scrollView.frame = calendarFrame
        for v in monthViews {
            v.frame = scrollView.bounds
        }
        scrollView.contentSize.width = calendarFrame.width
        
        for v in monthViews {
            v.relayout()
        }
        resetCalendarView()
        scrollView.contentOffset.y = monthViews[1].frame.minY
    }
    
    func resetCalendarView() {
        var y: CGFloat = 0
        var offset: CGFloat = 0
        for v in monthViews {
            v.frame.origin.y = y
            offset = v.lastWeekday == 7 ? 0 : v.dayHeight // 最後の週が土曜日で終わった時はカレンダーを重ねない
            y += v.frame.height - offset
        }
        scrollView.contentSize.height = y + offset
    }
    
    func makeLabel(text: NSString, frame: CGRect, font: UIFont = UIFont.systemFontOfSize(12)) -> UILabel {
        var label = UILabel(frame: frame)
        label.text = text
        label.font = font
        label.textColor = UIColor.blackColor()
        label.textAlignment = NSTextAlignment.Center
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.numberOfLines = 0
        return label
    }
    
    func makeScrollView() -> UIScrollView {
        var scrollView = UIScrollView(frame: self.bounds)
        scrollView.delegate = self
//        scrollView.pagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.scrollsToTop = false
        return scrollView
    }
    
//=================================
// UIScrollViewDelegate
//=================================
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        var y = scrollView.contentOffset.y
        if y + scrollView.frame.height >= scrollView.contentSize.height {
            showNextView()
        }
        else if y <= 0 {
            showPrevView()
        }
    }
    
    func showNextView () {
        scrollView.delegate = nil
        (currentYear, currentMonth) = getNextYearMonth()
        
        var offset = scrollView.contentOffset.y - monthViews[1].frame.minY
        
        (monthViews[1], monthViews[2]) = (monthViews[2], monthViews[1])
        (monthViews[2], monthViews[0]) = (monthViews[0], monthViews[2])
        
        var nextDate = getNextYearMonth()
        monthViews[2].setup(nextDate.year, month:nextDate.month)
        
        resetCalendarView()
        scrollView.contentOffset.y = offset
        
        delegate?.changedMonth(currentYear, month: currentMonth)
        scrollView.delegate = self
    }
    
    func showPrevView() {
        scrollView.delegate = nil
        (currentYear, currentMonth) = getPrevYearMonth()
        
        (monthViews[1], monthViews[0]) = (monthViews[0], monthViews[1])
        (monthViews[0], monthViews[2]) = (monthViews[2], monthViews[0])
        
        var prevDate = getPrevYearMonth()
        monthViews[0].setup(prevDate.year, month: prevDate.month)
        
        resetCalendarView()
        scrollView.contentOffset.y = monthViews[1].frame.minY
        
        delegate?.changedMonth(currentYear, month: currentMonth)
        scrollView.delegate = self
    }

//=================================
// Utility
//=================================
    
    // 今日の日付を取得
    func getCurrentDate() -> (year: Int, month: Int, day: Int) {
        let calendar = NSCalendar.currentCalendar()
        let flags: NSCalendarUnit =
            NSCalendarUnit.YearCalendarUnit |
            NSCalendarUnit.MonthCalendarUnit |
            NSCalendarUnit.DayCalendarUnit
        let comps = calendar.components(flags, fromDate: NSDate())
        return (comps.year, comps.month, comps.day)
    }
    
    // 次の月の年月を取得
    func getNextYearMonth() -> (year: Int, month: Int) {
        var nextYear = currentYear
        var nextMonth = currentMonth + 1
        if nextMonth > 12 {
            nextMonth = 1
            nextYear++
        }
        return (nextYear, nextMonth)
    }
    
    // 前の月の年月を取得
    func getPrevYearMonth() -> (year: Int, month: Int) {
        var prevYear = currentYear
        var prevMonth = currentMonth - 1
        if prevMonth < 1 {
            prevMonth = 12
            prevYear--
        }
        return (prevYear, prevMonth)
    }
    
}

public protocol CalendarDelegate {
    
    func changedMonth(year: Int, month: Int) -> Void
}
