//
//  CalendarView.swift
//  SchedulerForStudent
//
//  Copyright (c) 2014年 tanakasan2525. All rights reserved.
//

import UIKit

@IBDesignable public class CalendarView: UIView, UIScrollViewDelegate {
    
    // 現在表示している月
    public var current: Month!
    
    // 各要素の表示領域
    var weekdayFrame: CGRect!
    var calendarFrame: CGRect!
    
    // 曜日を表示するラベル
    var weekdayLabels = [UILabel]()
    
    // カレンダーのビュー
    var scrollView: UIScrollView!
    var monthViews = [CalendarMonthView]()
    
    // 選択している日にちのビュー
    var selectedDayView: CalendarDayView?
    
    // カレンダーの設定クラス
    private var _config = CalendarConfig()
    
    public var currentMonthView: CalendarMonthView {
        return monthViews[1]
    }
    
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
        
        // 曜日の表示
        for str in config.weekNotation {
            var label = makeLabel(str, frame: self.frame)
            addSubview(label)
            weekdayLabels.append(label)
        }
        // 土日の色を変える
        weekdayLabels[0].textColor = config.sundayColor
        weekdayLabels[6].textColor = config.saturdayColor
        
        // 現在の日付を取得
        current = Month.today()
        
        // 先月/今月/翌月のカレンダーを生成
        monthViews.append(CalendarMonthView(frame: frame, month: current.prev()))
        monthViews.append(CalendarMonthView(frame: frame, month: current))
        monthViews.append(CalendarMonthView(frame: frame, month: current.next()))
        
        // カレンダーの表示
        scrollView = makeScrollView()
        for v in monthViews {
            scrollView.addSubview(v)
            v.calendar = self
        }
        addSubview(scrollView)
        
        layoutSubviews()
        
        delegate?.changedMonth(current.year, month: current.month)
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
        scrollView.contentSize.width = calendarFrame.width
        
        for v in monthViews {
            v.frame = scrollView.bounds
            v.relayout()
        }
        
        resetCalendarView()
        scrollView.contentOffset.y = monthViews[1].frame.minY
    }
    
    func resetCalendarView() {
        // カレンダーの配置を調整
        var y: CGFloat = 0
        var offset: CGFloat = 0
        for v in monthViews {
            v.frame.origin.y = y
            offset = v.lastWeekday == .Saturday ? 0 : v.dayHeight // 最後の週が土曜日で終わった時はカレンダーを重ねない
            y += v.frame.height - offset
        }
        scrollView.contentSize.height = y + offset
        
        // カレンダーの色を再設定
        monthViews[0].backgroundColor = config.defaultBackgroundColor
        monthViews[1].backgroundColor = config.currentBackgroundColor
        monthViews[2].backgroundColor = config.defaultBackgroundColor
    }
    
    func makeLabel(text: NSString, frame: CGRect, font: UIFont = UIFont.systemFontOfSize(12)) -> UILabel {
        var label = UILabel(frame: frame)
        label.text = text
        label.font = font
        label.textColor = UIColor.blackColor()
        label.textAlignment = NSTextAlignment.Center
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
    
    public var config: CalendarConfig {
        get {
            return _config
        }
        set {
            _config = newValue
        }
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
        current = current.next()
        
        var offset = scrollView.contentOffset.y - monthViews[1].frame.minY
        
        (monthViews[1], monthViews[2]) = (monthViews[2], monthViews[1])
        (monthViews[2], monthViews[0]) = (monthViews[0], monthViews[2])
        
        monthViews[2].setup(current.next())
        
        resetCalendarView()
        scrollView.contentOffset.y = offset
        
        delegate?.changedMonth(current.year, month: current.month)
        scrollView.delegate = self
    }
    
    func showPrevView() {
        scrollView.delegate = nil
        current = current.prev()
        
        (monthViews[1], monthViews[0]) = (monthViews[0], monthViews[1])
        (monthViews[0], monthViews[2]) = (monthViews[2], monthViews[0])
        
        monthViews[0].setup(current.prev())
        
        resetCalendarView()
        scrollView.contentOffset.y = monthViews[1].frame.minY
        
        delegate?.changedMonth(current.year, month: current.month)
        scrollView.delegate = self
    }

//=================================
// Calendar Event
//=================================
    func daySelected(dayView: CalendarDayView) {
        selectedDayView?.unselect()
        selectedDayView = dayView
    }
    
    
}

public protocol CalendarDelegate {
    
    func changedMonth(year: Int, month: Int) -> Void
    
    func selectedDay(dayView: CalendarDayView) -> Void
}
