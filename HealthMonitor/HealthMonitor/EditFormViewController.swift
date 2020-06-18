//
//  EditFormViewController.swift
//  HealthMonitor
//
//  Created by Riccardo Cavallin on 08/05/2020.
//  Copyright © 2020 Riccardo Cavallin. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class EditFormViewController: UIViewController {
    
    @IBOutlet weak var temperatureField: UITextField!
    @IBOutlet weak var minPressureField: UITextField!
    @IBOutlet weak var maxPressureField: UITextField!
    @IBOutlet weak var glycemiaField: UITextField!
    @IBOutlet weak var heartRateField: UITextField!
    @IBOutlet weak var notesField: UITextField!
    @IBOutlet weak var okButton: UIButton!
    
    
    // oggetto report da modificare passato dal FirstViewController
    var report:Report? = nil
    // variabile per accedere alle preferenze dell'utente
    private let defaults = UserDefaults.standard
    private let model = Retrieve()
    let notificationPublisher = NotificationPublisher()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPlaceholders()
    }
    
    func setupAddTargetIsNotEmptyTextFields() {
        okButton.isEnabled = false
        temperatureField.addTarget(self, action: #selector(textFieldsIsNotEmpty), for: .editingChanged)
        minPressureField.addTarget(self, action: #selector(textFieldsIsNotEmpty), for: .editingChanged)
        maxPressureField.addTarget(self, action: #selector(textFieldsIsNotEmpty), for: .editingChanged)
        glycemiaField.addTarget(self, action: #selector(textFieldsIsNotEmpty), for: .editingChanged)
        heartRateField.addTarget(self, action: #selector(textFieldsIsNotEmpty), for: .editingChanged)
    }
    
    @objc func textFieldsIsNotEmpty(sender: UITextField) {

     sender.text = sender.text?.trimmingCharacters(in: .whitespaces)

     guard
        let temperatura = temperatureField.text, !temperatura.isEmpty, 
        let pressioneMin = minPressureField.text, !pressioneMin.isEmpty,
        let pressioneMax = maxPressureField.text, !pressioneMax.isEmpty,
        let glicemia = glycemiaField.text, !glicemia.isEmpty,
        let battito = heartRateField.text, !battito.isEmpty
    else {
        self.okButton.isEnabled = false
        return
        }
     // enable okButton if all conditions are met
     okButton.isEnabled = true
    }
    
    private func setPlaceholders() {
        if let _ = report?.temperatura, Int(truncating: report!.temperatura!) > 0  {
            temperatureField.text = "\(report!.temperatura!)"
        }
        if let _ = report?.pressioneMin, report!.pressioneMin > 0 {
            minPressureField.text = "\(report!.pressioneMin)"
        }
        if let _ = report?.pressioneMax, report!.pressioneMax > 0 {
           maxPressureField.text = "\(report!.pressioneMax)"
        }
        if let _ = report?.glicemia, report!.glicemia > 0{
           glycemiaField.text = "\(report!.glicemia)"
        }
        if let _ = report?.battito, report!.battito > 0 {
            heartRateField.text = "\(report!.battito)"
        }
        if let _ = report?.note, !report!.note!.isEmpty {
           notesField.text = "\(report!.note!)"
        }
        
    }
    
    @IBAction func updateReport(_ sender: Any) {
        
        let context = AppDelegate.viewContext
        
        if temperatureField.text != ""  {
            let itLocale = Locale(identifier: "us_US")
            report!.temperatura = NSDecimalNumber(string: temperatureField.text, locale: itLocale)
        }
        
        let pressioneMin = Int16(minPressureField.text!)
        if minPressureField.text != ""  && pressioneMin != nil {
          report!.pressioneMin = pressioneMin!
        }
        
        let pressioneMax = Int16(maxPressureField.text!)
        if maxPressureField.text != ""  && pressioneMax != nil {
            report!.pressioneMax = pressioneMax!
        }
        
        let glicemia = Int16(glycemiaField.text!)
        if glycemiaField.text != ""  && glicemia != nil {
            report!.glicemia = glicemia!
        }
        
        let battito = Int16(heartRateField.text!)
        if heartRateField.text != ""  && battito != nil {
            report!.battito = battito!
        }
        
        report!.note = notesField.text
        
        resetLabels()
        
        // salvataggio nel database
        do {
            try context.save()
        } catch {
            fatalError("Errore nel salvataggio: \(error)")
        }
        
        checkForMonitor()
        
    }
    
    // funzione che verifica se la data odierna è quella di scadenza del monitoraggio
    // in tal caso manda una notifica con il risultato
    private func checkForMonitor() {
        if let scadenza = defaults.object(forKey: "scadenza") as? Date {
            let calendar = Calendar.current
            let today = calendar.component(.day, from: Date())
            let giornoScadenza = calendar.component(.day, from: scadenza)
            let parametro = defaults.integer(forKey: "parametro")
            let result = model.media(parametro: parametro) as? Double
            let soglia = Double(defaults.integer(forKey: "soglia"))
            var body = ""
            let monitora = defaults.bool(forKey: "monitora")
            
            if result == nil && today >= giornoScadenza && monitora {
                body = "Non è stato possibile effettuare il monitoraggio perchè non hai inserito i valori necessari."
                notificationPublisher.sendResultMonitorNotification(title: "Risultati monitoraggio", body: body, badge: 1, sound: .default, secondsLeft: 5, id: "risultatiMonitoraggio")
                // pongo fine al monitoraggio
                defaults.set(false, forKey: "monitora")
            }
            else if today >= giornoScadenza && monitora {
                switch parametro {
                    
                case 0: // temperatura

                    if result! > soglia {
                        body = "La temperatura media monitorata è \(result!). È più alta rispetto al valore soglia impostato a \(soglia)."
                    } else {
                        body = "Complimenti! La temperatura media monitorata è \(result!). Hai rispettato il valore soglia di \(soglia)."
                    }
                    
                case 1: // pressione minima
                    if result! > soglia {
                        body = "La pressione minima media monitorata è \(result!). È più alta rispetto al valore soglia impostato a \(soglia)."
                    } else {
                        body = "Complimenti! La pressione minima media monitorata è \(result!). Hai rispettato il valore soglia di \(soglia)."
                    }
                    
                case 2: // pressione massima
                    if result! > soglia {
                        body = "La pressione massima media monitorata è \(result!). È più alta rispetto al valore soglia impostato a \(soglia)."
                    } else {
                        body = "Complimenti! La pressione massima media monitorata è \(result!). Hai rispettato il valore soglia di \(soglia)."
                    }
                    
                case 3: // glicemia
                    if result! > soglia {
                        body = "La glicemia media monitorata è \(result!). È più alta rispetto al valore soglia impostato a \(soglia)."
                    } else {
                        body = "Complimenti! La glicemia media monitorata è \(result!). Hai rispettato il valore soglia di \(soglia)."
                    }
                    
                case 4: // battito
                    if result! > soglia {
                        body = "Il battito cardiaco medio monitorato è \(result!). È più alta rispetto al valore soglia impostato a \(soglia)."
                    } else {
                        body = "Complimenti! Il battito cardiaco medio monitorato è \(result!). Hai rispettato il valore soglia di \(soglia)."
                    }
                    
                default:
                    print("Default case")
                }
                notificationPublisher.sendResultMonitorNotification(title: "Risultati monitoraggio", body: body, badge: 1, sound: .default, secondsLeft: 5, id: "risultatiMonitoraggio")
                // pongo fine al monitoraggio
                defaults.set(false, forKey: "monitora")
            }
            
        }
        
    }

    
    private func resetLabels() {
        // reset delle labels
        temperatureField.text = nil
        maxPressureField.text = nil
        minPressureField.text = nil
        glycemiaField.text = nil
        heartRateField.text = nil
        notesField.text = nil
    }
}
