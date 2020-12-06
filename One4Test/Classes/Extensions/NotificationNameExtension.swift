//
//  NotificationNameExtension.swift
//  One4Test
//
//  Created by Andrea Mario Lufino on 06/12/20.
//

import Foundation


extension Notification.Name {
    
    struct Stargazers {
        
        static let didStartFetching                         = Notification.Name.init(rawValue: "stargazersDidStartFetching")
        static let didFinishFetchWithSuccess                = Notification.Name.init(rawValue: "stargazersDidFinishFetchWithSuccess")
        static let didFinishFetchWithError                  = Notification.Name.init(rawValue: "stargazersDidFinishFetchWithError")
        static let didFinishFetch                           = Notification.Name.init(rawValue: "stargazersDidFinishFetch")
    }
}
