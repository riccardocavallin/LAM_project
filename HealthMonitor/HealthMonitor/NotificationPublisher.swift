//
//  NotificationPublisher.swift
//  HealthMonitor
//
//  Created by Riccardo Cavallin on 12/05/2020.
//  Copyright © 2020 Riccardo Cavallin. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

class NotificationPublisher {
    
   func sendNotification(title: String, body: String, badge: Int, sound: UNNotificationSound, hour: Int, minute: Int, id: String, idAction: String, idTitle: String) {
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        // aggiungo 1 al badge di notifica
        content.badge = NSNumber(value: UIApplication.shared.applicationIconBadgeNumber + badge)
        content.sound = sound
        content.categoryIdentifier = "category"
        
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let id = id
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if error != nil {
                print(error!.localizedDescription)
            }
        }
       
        
        
        // action
        let action = UNNotificationAction(identifier: idAction, title: idTitle, options: .foreground)
        let category = UNNotificationCategory(identifier: "category", actions: [action], intentIdentifiers: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
        
    }
    
    func deleteNotification(id: String) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [id])
    }
    
    
    
}

