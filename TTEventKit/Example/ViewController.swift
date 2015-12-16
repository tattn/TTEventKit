//
//  ViewController.swift
//  Example
//
//  Copyright (c) 2014年 tattn. All rights reserved.
//

import UIKit
import EventKit
import TTEventKit

class ViewController: UIViewController, CalendarDelegate {
    
    @IBOutlet weak var calendarView: CalendarView!

    @IBOutlet weak var header: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarView.delegate = self
        
        let year = calendarView.current.year
        let month = calendarView.current.month
        changedMonth(year, month: month)
        
        EventStore.requestAccess() { (granted, error) in
            if !granted {
                dispatch_async(dispatch_get_main_queue()) {
                    let alert = UIAlertView(title: "Error", message: "カレンダーへのアクセスを許可してください。", delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "OK")
                    alert.show()
                    
                }
            }
        }
        
        let ev = EventStore.getEvents(Month(year: 2017, month: 1))
        
        if ev  != nil {
            for e in ev {
                print("Title \(e.title)")
                print("startDate: \(e.startDate)")
                print("endDate: \(e.endDate)")
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func tappedAddButton(sender: UIBarButtonItem) {
        
        let event = EventStore.create()
        event.title = "元旦"
        event.startDate = Month(year: 2017, month: 1).nsdate
        event.endDate = event.startDate
        event.notes = "メモ"
        EventUI.showEditView(event)
    }
    
//=================================
// Calendar Delegate
//=================================
    
    func changedMonth(year: Int, month: Int) {
        let monthEn = ["January", "Febrary", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
        
        header.title = "\(year) \(monthEn[month - 1])"
        
    }
    
    func selectedDay(dayView: CalendarDayView) {
        
    }

}

