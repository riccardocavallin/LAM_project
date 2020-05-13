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
    private let notificationPublisher = NotificationPublisher()
    
    override func viewDidLoad() {
        
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
        notificationPublisher.deleteNotification(id: "reportReminder")
        let date = hourPicker.date
        let components = Calendar.current.dateComponents([.day, .hour, .minute], from: date)
        let day = components.day!
        let hour = components.hour!
        let minute = components.minute!
        saveHourNotificationPreference(hour: hour, minute: minute)
        if minute < 10 {
           oraImpostata.text = "Impostato alle \(hour):0\(minute)"
        } else {
           oraImpostata.text = "Impostato alle \(hour):\(minute)"
        }
        // imposto uan nuova notifica per il nuovo orario
        notificationPublisher.sendNotification(title: "Report giornaliero", body: "Inserisci il tuo report odierno", badge: 1, sound: .default, day: day, hour: hour, minute: minute, id: "reportReminder", idAction: "posticipa", idTitle: "Posticipa")
    }
    
    private func saveHourNotificationPreference(hour: Int, minute: Int) {
        defaults.set(hour, forKey: "oraNotificaReport")
        defaults.set(minute, forKey: "minutoNotificaReport")
    }
    
    private func checkForHourPreference() -> (hour: Int, minute: Int) {
        let hour = defaults.integer(forKey: "oraNotificaReport")
        let minute = defaults.integer(forKey: "minutoNotificaReport")
        if (hour == 0 && minute == 0) {
            oraImpostata.isHidden = true
        }
        return (hour, minute)
    }
    

}
