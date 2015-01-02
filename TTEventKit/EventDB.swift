//
//  EventDB.swift
//  TTEventKit
//
//  Created by Tanaka Tatsuya on 2014/12/26.
//  Copyright (c) 2014年 tanakasan2525. All rights reserved.
//

import Foundation
import EventKit

public struct EventDB {
    
    public static var store = EKEventStore()
    
    /// カレンダーへのアクセス許可を要求します
    public static func requestAccess() {
        requestAccess() { (granted) in
            dispatch_async(dispatch_get_main_queue()) {
                let alert = UIAlertView(title: "エラー", message: "カレンダーへのアクセスを許可してください。", delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "OK")
                alert.show()
                
            }
        }
    }
    
    /// カレンダーへのアクセス許可を要求します
    public static func requestAccess(completion: (granted: Bool) -> Void) {
        store.requestAccessToEntityType(EKEntityTypeEvent) { (granted, error) in
            completion(granted: granted)
        }
    }
    
//=================================
// Get
//=================================
    
    /// カレンダーからイベントを取得します。
    public static func getEvents(year: Int, month: Int) -> [EKEvent]! {
        return getEvents(Month(year: year, month: month))
    }
    
    /// カレンダーからイベントを取得します。
    public static func getEvents(month: Month) -> [EKEvent]! {
        
        let len = month.length()
        
        return getEvents(month, day: 1, length: len)
    }
    
    /// カレンダーからイベントを取得します。
    public static func getEvents(month: Month, day: Int, length: Int = 1) -> [EKEvent]! {
        
        let start = month.nsdate.dateByAddingTimeInterval(60*60*24*Double(day - 1))
        let end = start.dateByAddingTimeInterval(60*60*24*Double(length))
        
        return getEvents(start, endDate: end)
    }
    
    /// カレンダーからイベントを取得します。
    public static func getEvents(startDate: NSDate, endDate: NSDate) -> [EKEvent]! {
        let predicate = store.predicateForEventsWithStartDate(startDate, endDate: endDate, calendars: nil)
        
        return store.eventsMatchingPredicate(predicate) as [EKEvent]!
    }
    
//=================================
// Add
//=================================
    
    /// カレンダーにイベントを追加します。
    public static func addEvent(title: String, notes: String,
                                startDate: NSDate = NSDate(), endDate: NSDate = NSDate()) {
        var event = EKEvent(eventStore: store)
        event.title = title
        event.startDate = startDate
        event.endDate = endDate
        event.notes = notes
        addEvent(event)
    }
    
    /// カレンダーにイベントを追加します。
    public static func addEvent(event: EKEvent) {
        event.calendar = store.defaultCalendarForNewEvents
        store.saveEvent(event, span: EKSpanThisEvent, error: nil)
    }
    
//=================================
// Remove
//=================================
    
    /// カレンダーからイベントを削除します。
    public static func removeEvents(startDate: NSDate, endDate: NSDate) {
        let events = getEvents(startDate, endDate: endDate)
        removeEvents(events)
    }
    
    /// カレンダーからイベントを削除します。
    public static func removeEvents(month: Month) {
        let events = getEvents(month)
        removeEvents(events)
    }
    
    /// カレンダーからイベントを削除します。
    public static func removeEvents(month: Month, day: Int, length: Int = 1) {
        let events = getEvents(month, day: day, length: length)
        removeEvents(events)
    }
    
    /// カレンダーからイベントを削除します。
    public static func removeEvents(events: [EKEvent]!) {
        if events != nil {
            for event in events {
                removeEvent(event)
            }
        }
    }
    
    /// カレンダーからイベントを削除します。
    public static func removeEvent(event: EKEvent) {
        store.removeEvent(event, span: EKSpanThisEvent, error: nil)
    }
    
    
//=================================
// Utility
//=================================
    
    public static func create() -> EKEvent {
        return EKEvent(eventStore: store)
    }
    
}
