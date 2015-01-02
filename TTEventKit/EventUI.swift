//
//  EventUI.swift
//  TTEventKit
//
//  Created by Tanaka Tatsuya on 2015/01/02.
//  Copyright (c) 2015年 tanakasan2525. All rights reserved.
//

import Foundation
import UIKit
import EventKit
import EventKitUI

public struct EventUI {
    
    private static var eventDelegate = EventDelegate()
    
    public static func showEditView() {
        showEditView(EKEvent(eventStore: EventDB.store))
    }
    
    public static func showEditView(event: EKEvent) {
        
        let viewCtrl = EKEventEditViewController()
        viewCtrl.editViewDelegate = eventDelegate
        viewCtrl.event = event
        viewCtrl.eventStore = EventDB.store
    
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
        private func eventEditViewController(controller: EKEventEditViewController!, didCompleteWithAction action: EKEventEditViewAction) {
            
            switch action.value {
            case EKEventEditViewActionCanceled.value:
                break
                
            case EKEventEditViewActionSaved.value:
                EventDB.addEvent(controller.event)
                break
                
            case EKEventEditViewActionDeleted.value:
                EventDB.removeEvent(controller.event)
                break
                
            default:
                break
            }
            
            controller.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
}