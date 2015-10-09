//
//  EventUI.swift
//  TTEventKit
//
//  Created by Tanaka Tatsuya on 2015/01/02.
//  Copyright (c) 2015年 tattn. All rights reserved.
//

import Foundation
import UIKit
import EventKit
import EventKitUI

public struct EventUI {
    
    private static var eventDelegate = EventDelegate()
    
    public static func showEditView() {
        showEditView(EventStore.create())
    }
    
    public static func showEditView(event: EKEvent) {
        let viewCtrl = EKEventEditViewController()
        viewCtrl.editViewDelegate = eventDelegate
        viewCtrl.event = event
        viewCtrl.eventStore = EventStore.store
    
        currentViewController()?.presentViewController(viewCtrl, animated: true, completion: nil)
    }
    
    private static func currentViewController() -> UIViewController? {
        var top = UIApplication.sharedApplication().keyWindow?.rootViewController
        
        while (top?.presentedViewController != nil) {
            top = top?.presentedViewController
        }
        
        return top
    }
    
    private class EventDelegate : NSObject, EKEventEditViewDelegate {
        @objc private func eventEditViewController(controller: EKEventEditViewController, didCompleteWithAction action: EKEventEditViewAction) {
            
            switch action {
            case .Canceled:
                break
                
            case .Saved:
                EventStore.addEvent(controller.event!)
                break
                
            case .Deleted:
                EventStore.removeEvent(controller.event!)
                break
            }
            
            controller.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
}