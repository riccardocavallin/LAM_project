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
    
    func sendReportReminderNotification(title: String, body: String, badge: Int, sound: UNNotificationSound, day: Int, hour: Int, minute: Int, id: String, idAction: String, idTitle: String) {
        
        // azione di posticipa notifica
        let postponeAction = UNNotificationAction(identifier: "posticipa", title: "Posticipa di 30 min" , options: [])
        
        // categorie
        let category = UNNotificationCategory(identifier: "reportCategory", actions: [postponeAction], intentIdentifiers: [], options: [])
        
        // aggiungo la categoria al framework delle notifiche
        UNUserNotificationCenter.current().setNotificationCategories([category])
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        // aggiungo 1 al badge di notifica
        content.badge = NSNumber(value: UIApplication.shared.applicationIconBadgeNumber + badge)
        content.sound = sound
        content.categoryIdentifier = "reportCategory"
        
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        dateComponents.hour = day
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
        
    }
    
    func deleteNotification(id: String) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [id])
    }
    
}

