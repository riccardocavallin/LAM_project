//
//  ThirdViewController.swift
//  HealthMonitor
//
//  Created by Riccardo Cavallin on 11/05/2020.
//  Copyright © 2020 Riccardo Cavallin. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {

    @IBOutlet weak var hourPicker: UIDatePicker!
    @IBOutlet weak var oraImpostata: UILabel!
    
    let defaults = UserDefaults.standard // variabile per accedere alle preferenze dell'utente
    let notificationCenter = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        
        // richiesta permesso di notifica
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in }
        
        hourPicker.datePickerMode = .time
        let hour = checkForHourPreference().hour
        let minute = checkForHourPreference().minute
        if minute < 10 {
           oraImpostata.text = "Attualmente impostata alle \(hour) : 0\(minute)"
        } else {
           oraImpostata.text = "Attualmente impostata alle \(hour) : \(minute)"
        }
       
        
    }
    
    @IBAction func valueChanged(_ sender: Any) {
        // rimuovo la notifica precedentemente programmata
        deleteNotification(id: "reportReminder")
        let date = hourPicker.date
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        let hour = components.hour!
        let minute = components.minute!
        saveHourNotificationPreference(hour: hour, minute: minute)
        oraImpostata.text = "Impostato alle \(hour):\(minute)"
        // imposto uan nuova notifica per il nuovo orario
        setReportNotification(hour: hour, minute: minute)
    }
    
    func saveHourNotificationPreference(hour: Int, minute: Int) {
        defaults.set(hour, forKey: "oraNotificaReport")
        defaults.set(minute, forKey: "minutoNotificaReport")
    }
    
    func checkForHourPreference() -> (hour: Int, minute: Int) {
        let hour = defaults.integer(forKey: "oraNotificaReport")
        let minute = defaults.integer(forKey: "minutoNotificaReport")
        if (hour == 0 && minute == 0) {
            oraImpostata.isHidden = true
        }
        return (hour, minute)
    }
    
    private func deleteNotification(id: String) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["reportReminder"])
    }
    
    private func setReportNotification(hour: Int, minute: Int) {
        
        let content = UNMutableNotificationContent()
        content.title = "Report giornaliero"
        content.body = "Inserisci il tuo report odierno"
        // aggiungo 1 al badge di notifica
        content.badge = NSNumber(value: UIApplication.shared.applicationIconBadgeNumber + 1)
        content.sound = UNNotificationSound.default
        
//        // invia notifica di test dopo 5 secondi
//        let date = Date().addingTimeInterval(5)
//        let dateComponents = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let id = "reportReminder"
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        notificationCenter.add(request) { (error) in
            if error != nil {
                print(error?.localizedDescription)
            }
        }
        
    }

}
