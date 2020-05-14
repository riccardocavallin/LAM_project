//
//  ThirdViewController.swift
//  HealthMonitor
//
//  Created by Riccardo Cavallin on 11/05/2020.
//  Copyright © 2020 Riccardo Cavallin. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var hourPicker: UIDatePicker!
    @IBOutlet weak var oraImpostata: UILabel!
    @IBOutlet weak var paramPicker: UIPickerView!
    @IBOutlet weak var parametroImpostato: UILabel!
    @IBOutlet weak var durataField: UITextField!
    @IBOutlet weak var sogliaField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    
    let defaults = UserDefaults.standard // variabile per accedere alle preferenze dell'utente
    private let notificationPublisher = NotificationPublisher()
    var pickerData = ["Temperatura", "Pressione minima", "Pressione massima", "Glicemia", "Battito"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.paramPicker.delegate = self
        self.paramPicker.dataSource = self
        hourPicker.datePickerMode = .time
        setupAddTargetIsNotEmptyTextFields()
        setDefaultLabels()
    }
    
    private func setDefaultLabels() {
        let hour = checkForHourPreference().hour
        let minute = checkForHourPreference().minute
        if minute < 10 {
           oraImpostata.text = "Attualmente impostata alle \(hour) : 0\(minute)"
        } else {
           oraImpostata.text = "Attualmente impostata alle \(hour) : \(minute)"
        }
        let parametroMonitrato = defaults.integer(forKey: "monitora")
        let isParamSetted = defaults.bool(forKey: "clicked")
        if (isParamSetted) {
            parametroImpostato.text = "Attualmente impostato a \(pickerData[parametroMonitrato])"
        }
    }
    
    // funzioni della classe UIPickerViewDataSource
    // numero di colonne
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    // numero di righe
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    // titolo della riga
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    // azioni da fare quando viene selazionato un elemento
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        defaults.set(true, forKey: "clicked")
        defaults.set(row, forKey: "monitora")
        parametroImpostato.text = "Attualmente impostato a \(pickerData[row])"
        
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
        notificationPublisher.sendReportReminderNotification(title: "Report giornaliero", body: "Inserisci il tuo report odierno", badge: 1, sound: .default, day: day, hour: hour, minute: minute, id: "reportReminder", idAction: "posticipa", idTitle: "Posticipa")
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
    
    private func setupAddTargetIsNotEmptyTextFields() {
        confirmButton.isEnabled = false
        durataField.addTarget(self, action: #selector(textFieldsIsNotEmpty), for: .editingChanged)
        sogliaField.addTarget(self, action: #selector(textFieldsIsNotEmpty), for: .editingChanged)
    }
    
    // attiva il bottone all'inserimento dei dati
    @objc func textFieldsIsNotEmpty(sender: UITextField) {

     sender.text = sender.text?.trimmingCharacters(in: .whitespaces)

     guard
        let durata = durataField.text, !durata.isEmpty,
        let soglia = sogliaField.text, !soglia.isEmpty
    else {
        self.confirmButton.isEnabled = false
        return
        }
     // enable okButton if all conditions are met
     confirmButton.isEnabled = true
    }
    
    // viene cliccato il bottone "ok"
    @IBAction func insertPref(_ sender: Any) {
        let durata = Int(durataField.text!)
        let soglia = Int(sogliaField.text!)
        defaults.set(durata, forKey: "durata")
        defaults.set(soglia, forKey: "soglia")
        print(defaults.integer(forKey: "durata"))
        print(defaults.integer(forKey: "soglia"))
        resetLabels()
    }
    
    private func resetLabels() {
        durataField.text = nil
        sogliaField.text = nil
        confirmButton.isEnabled = false
    }
    

}
