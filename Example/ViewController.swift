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

