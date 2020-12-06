//
//  Notifier.swift
//
//  Created by Andrea Mario Lufino on 08/08/17.
//  Copyright © 2017 Andrea Mario Lufino. All rights reserved.
//

import Foundation
import UIKit


// MARK: - Notifier

/// Wrapper around NotificationCenter that simplifies the syntax. It doesn't provide methods with blocks.
class Notifier {
    
    fileprivate static var notificationCenter: NotificationCenter {
        return NotificationCenter.default
    }
    
    static func post(_ notification: Notification.Name, object: Any? = nil, userInfo: [AnyHashable : Any]? = nil) {
        
        notificationCenter.post(Notification.init(name: notification, object: object, userInfo: userInfo))
    }
    
    static func addObserver(_ observer: Any, for notification: Notification.Name, selector: Selector, object: Any? = nil) {
        
        notificationCenter.addObserver(observer, selector: selector, name: notification, object: object)
    }
    
    static func removeObserver(_ observer: Any) {
        
        notificationCenter.removeObserver(observer)
    }
}
