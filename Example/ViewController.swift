//
//  ViewController.swift
//  Example
//
//  Copyright (c) 2014年 tanakasan2525. All rights reserved.
//

import UIKit
import EventKit
import TTEventKit

class ViewController: UIViewController, CalendarDelegate {
    
    @IBOutlet weak var calendarView: CalendarView!

    @IBOutlet weak var header: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarView.delegate = self
        
        let year = calendarView.current.year
        let month = calendarView.current.month
        changedMonth(year, month: month)
        
        EventDB.requestAccess() { (granted) in
            if !granted {
                dispatch_async(dispatch_get_main_queue()) {
                    let alert = UIAlertView(title: "エラー", message: "カレンダーへのアクセスを許可してください。", delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "OK")
                    alert.show()
                    
                }
            }
        }
        
        let startDate = Month(year: 2015, month: 1).nsdate
        EventDB.addEvent("元旦", notes: "元旦だよ", startDate: startDate, endDate: startDate)
        
        let ev = EventDB.getEvents(Month(year: 2014, month: 12))
        
        if ev  != nil {
            for e in ev {
                println("Title \(e.title)")
                println("startDate: \(e.startDate)")
                println("endDate: \(e.endDate)")
                
                
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
//=================================
// Calendar Delegate
//=================================
    
    func changedMonth(year: Int, month: Int) {
        let monthEn = ["January", "Febrary", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
        
        header.text = "\(year) \(monthEn[month - 1])"
        
    }
    
    func selectedDay(dayView: CalendarDayView) {
        
    }

}

