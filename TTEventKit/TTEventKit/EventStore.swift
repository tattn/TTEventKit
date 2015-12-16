//
//  EventDB.swift
//  TTEventKit
//
//  Created by Tanaka Tatsuya on 2014/12/26.
//  Copyright (c) 2014年 tattn. All rights reserved.
//

import Foundation
import EventKit

public struct EventStore {
    
    public static var store = EKEventStore()
    
    /// カレンダーへのアクセス許可を要求します
    public static func requestAccess(completion: (granted: Bool, error: NSError?) -> Void) {
        store.requestAccessToEntityType(EKEntityType.Event) { (granted, error) in
            completion(granted: granted, error: error)
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
    public static func getEvents(year: Int, month: Int, day: Int, length: Int = 1) -> [EKEvent]! {
        return getEvents(Month(year: year, month: month), day: day, length: length)
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
    public static func addEvent(title: String, notes: String, date: NSDate = NSDate()) {
            let event = EKEvent(eventStore: store)
            event.title = title
            event.startDate = date
            event.endDate = date
            event.notes = notes
            event.allDay = true
            addEvent(event)
    }
    
    /// カレンダーにイベントを追加します。
    public static func addEvent(title: String, notes: String,
        startDate: NSDate = NSDate(), endDate: NSDate = NSDate(), allDay: Bool = false) {
        let event = EKEvent(eventStore: store)
        event.title = title
        event.startDate = startDate
        event.endDate = endDate
        event.notes = notes
        event.allDay = allDay
        addEvent(event)
    }
    
    /// カレンダーにイベントを追加します。
    public static func addEvent(event: EKEvent) {
        event.calendar = store.defaultCalendarForNewEvents
        do {
            try store.saveEvent(event, span: .ThisEvent)
        } catch _ {
        }
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
    public static func removeEvents(year: Int, month: Int) {
        removeEvents(Month(year: year, month: month))
    }
    
    /// カレンダーからイベントを削除します。
    public static func removeEvents(month: Month) {
        let events = getEvents(month)
        removeEvents(events)
    }
    
    /// カレンダーからイベントを削除します。
    public static func removeEvents(year: Int, month: Int, day: Int, length: Int = 1) {
        removeEvents(Month(year: year, month: month), day: day, length: length)
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
        do {
            try store.removeEvent(event, span: .ThisEvent)
        } catch _ {
        }
    }
    
    
//=================================
// Utility
//=================================
    
    public static func create() -> EKEvent {
        return EKEvent(eventStore: store)
    }
    
}
