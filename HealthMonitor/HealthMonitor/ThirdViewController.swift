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
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        hourPicker.datePickerMode = .time
        let hour = checkForHourPreference().hour
        let minute = checkForHourPreference().minute
        oraImpostata.text = "Attualmente impostata alle \(hour) : \(minute)"
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func valueChanged(_ sender: Any) {
        let date = hourPicker.date
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        let hour = components.hour!
        let minute = components.minute!
        saveHourNotificationPreference(hour: hour, minute: minute)
        oraImpostata.text = "Impostato alle \(hour):\(minute)"

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

}
