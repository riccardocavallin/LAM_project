//
//  FormViewController.swift
//  HealthMonitor
//
//  Created by Riccardo Cavallin on 05/05/2020.
//  Copyright © 2020 Riccardo Cavallin. All rights reserved.
//

import UIKit
import CoreData

class FormViewController: UIViewController {
    
    @IBOutlet weak var temperatureField: UITextField!
    @IBOutlet weak var minPressureField: UITextField!
    @IBOutlet weak var maxPressureField: UITextField!
    @IBOutlet weak var glycemiaField: UITextField!
    @IBOutlet weak var heartRateField: UITextField!
    @IBOutlet weak var notesField: UITextField!
	@IBOutlet weak var okButton: UIButton!
	
    // variabile data passata dal FirstViewController
    var data: Date? = nil
	private let notificationPublisher = NotificationPublisher()
	// variabile per accedere alle preferenze dell'utente
	private let defaults = UserDefaults.standard
	private let model = Retrieve()
    
    override func viewDidLoad() {
        super.viewDidLoad()
		setupAddTargetIsNotEmptyTextFields()
	}
	
	private func setupAddTargetIsNotEmptyTextFields() {
		okButton.isEnabled = false
		temperatureField.addTarget(self, action: #selector(textFieldsIsNotEmpty), for: .editingChanged)
		minPressureField.addTarget(self, action: #selector(textFieldsIsNotEmpty), for: .editingChanged)
		maxPressureField.addTarget(self, action: #selector(textFieldsIsNotEmpty), for: .editingChanged)
		glycemiaField.addTarget(self, action: #selector(textFieldsIsNotEmpty), for: .editingChanged)
		heartRateField.addTarget(self, action: #selector(textFieldsIsNotEmpty), for: .editingChanged)
	}
	
	// attiva il bottone all'inserimento dei dati
	@objc func textFieldsIsNotEmpty(sender: UITextField) {
		
		sender.text = sender.text?.trimmingCharacters(in: .whitespaces)
		var count = 0
		if let temperatura = temperatureField.text, !temperatura.isEmpty { count += 1 }
		if let pressioneMin = minPressureField.text, !pressioneMin.isEmpty { count += 1 }
		if let pressioneMax = maxPressureField.text, !pressioneMax.isEmpty { count += 1 }
		if let glicemia = glycemiaField.text, !glicemia.isEmpty { count += 1 }
		if let battito = heartRateField.text, !battito.isEmpty { count += 1 }
		
		if count >= 2 {
			self.okButton.isEnabled = true
		} else {
			self.okButton.isEnabled = false
			return
		}
		// enable okButton if all conditions are met
		okButton.isEnabled = true
	}
    
    // cliccando su ok viene creato l'oggetto report
    @IBAction func insertReport(_ sender: Any) {
        let context = AppDelegate.viewContext
        let report = Report(context: context)
        
		// se il form viene attivato dalle notifiche data è nil
		// viene quindi assegnata alla data corrente
		if data == nil {
			data = Date()
		}
		
		var priorita = 0
		
		// estraggo solo il giorno, mese, anno
		let dataIns = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: data!))
        report.data = dataIns! // controllo se arrivo da notifiche
		
		if !minPressureField.text!.isEmpty {
			report.pressioneMin = Int16(minPressureField.text!)!
			priorita = 1
		} else {
			report.pressioneMin = 0
		}
		
		if !maxPressureField.text!.isEmpty {
			report.pressioneMax = Int16(maxPressureField.text!)!
			priorita = 1
		} else {
			report.pressioneMax = 0
		}
		
		if !heartRateField.text!.isEmpty {
			report.battito = Int16(heartRateField.text!)!
			priorita = 3
		} else {
			report.battito = 0
		}
		
		let itLocale = Locale(identifier: "it_IT")
		if !temperatureField.text!.isEmpty{
			report.temperatura = NSDecimalNumber(string: temperatureField.text, locale: itLocale)
			priorita = 4
		} else {
			report.temperatura = 0
		}
		
		if !glycemiaField.text!.isEmpty {
			report.glicemia = Int16(glycemiaField.text!)!
			priorita = 5
		} else {
			report.glicemia = 0
		}
		
		if !notesField.text!.isEmpty {
			report.note = notesField.text
		}
		
		// salvo priorità
		report.priorita = Int16(priorita)
        
		resetLabels()
        
        // salvataggio nel database
        do {
            try context.save()
			// tolgo la notifica per oggi e la imposto per domani
			notificationPublisher.deleteNotification(id: "reportReminder")
			let date = Date()
			let calendar = Calendar.current
			let dayCurrent = calendar.component(.day, from: date)
			let hour = defaults.integer(forKey: "oraNotificaReport")
			let minute = defaults.integer(forKey: "minutoNotificaReport")
			// imposto uan nuova notifica per domani
			notificationPublisher.sendReportReminderNotification(title: "Report giornaliero", body: "Inserisci il tuo report odierno", badge: 1, sound: .default, day: dayCurrent+1 , hour: hour, minute: minute, id: "reportReminder", idAction: "posticipa", idTitle: "Posticipa")
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
				let result = model.media(parametro: parametro) as! Int16
				let soglia = defaults.integer(forKey: "soglia")
				var body = ""
			
			if today >= giornoScadenza {
				switch parametro {
					
				case 0: // temperatura
					if result > soglia {
						body = "La temperatura media monitorata è \(result). È più alta rispetto al valore soglia impostato a \(soglia)."
					} else {
						body = "Complimenti! La temperatura media monitorata è \(result). Hai rispettato il valore soglia di \(soglia)."
					}
					notificationPublisher.sendResultMonitorNotification(title: "Risultati monitoraggio", body: body, badge: 1, sound: .default, secondsLeft: 5, id: "risultatiMonitoraggio")
					
				case 1: // pressione minima
					if result > soglia {
						body = "La pressione minima media monitorata è \(result). È più alta rispetto al valore soglia impostato a \(soglia)."
					} else {
						body = "Complimenti! La pressione minima media monitorata è \(result). Hai rispettato il valore soglia di \(soglia)."
					}
					notificationPublisher.sendResultMonitorNotification(title: "Risultati monitoraggio", body: body, badge: 1, sound: .default, secondsLeft: 5, id: "risultatiMonitoraggio")
					
				case 2: // pressione massima
					if result > soglia {
						body = "La pressione massima media monitorata è \(result). È più alta rispetto al valore soglia impostato a \(soglia)."
					} else {
						body = "Complimenti! La pressione massima media monitorata è \(result). Hai rispettato il valore soglia di \(soglia)."
					}
					notificationPublisher.sendResultMonitorNotification(title: "Risultati monitoraggio", body: body, badge: 1, sound: .default, secondsLeft: 5, id: "risultatiMonitoraggio")
					
				case 3: // glicemia
					if result > soglia {
						body = "La glicemia media monitorata è \(result). È più alta rispetto al valore soglia impostato a \(soglia)."
					} else {
						body = "Complimenti! La glicemia media monitorata è \(result). Hai rispettato il valore soglia di \(soglia)."
					}
					notificationPublisher.sendResultMonitorNotification(title: "Risultati monitoraggio", body: body, badge: 1, sound: .default, secondsLeft: 5, id: "risultatiMonitoraggio")
					
				case 4: // battito
					if result > soglia {
						body = "Il battito cardiaco medio monitorato è \(result). È più alta rispetto al valore soglia impostato a \(soglia)."
					} else {
						body = "Complimenti! Il battito cardiaco medio monitorato è \(result). Hai rispettato il valore soglia di \(soglia)."
					}
					notificationPublisher.sendResultMonitorNotification(title: "Risultati monitoraggio", body: body, badge: 1, sound: .default, secondsLeft: 5, id: "risultatiMonitoraggio")
					
				default:
					print("Default case")
				}
				
			}
		}
		
	}
	
	private func resetLabels() {
        temperatureField.text = nil
        maxPressureField.text = nil
        minPressureField.text = nil
        glycemiaField.text = nil
        heartRateField.text = nil
        notesField.text = nil
		okButton.isEnabled = false
	}


}
