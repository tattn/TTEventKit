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
    
    private static var store = EKEventStore()
    
    public static func requestAccess() {
        requestAccess() { (granted) in
            dispatch_async(dispatch_get_main_queue()) {
                let alert = UIAlertView(title: "エラー", message: "カレンダーへのアクセスを許可してください。", delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "OK")
                alert.show()
                
            }
        }
    }
    
    public static func requestAccess(completion: (granted: Bool) -> Void) {
        store.requestAccessToEntityType(EKEntityTypeEvent) { (granted, error) in
            completion(granted: granted)
        }
    }
    
    public static func getEvents(month: Month) -> [EKEvent]! {
        
        let len = Double(month.length())
        let start = month.nsdate
        let end = start.dateByAddingTimeInterval(60*60*24*len)
        
        let predicate = store.predicateForEventsWithStartDate(start, endDate: end, calendars: nil)
        
        return store.eventsMatchingPredicate(predicate) as [EKEvent]!
    }
    
}
