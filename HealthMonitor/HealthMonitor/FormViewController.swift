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
	let defaults = UserDefaults.standard
    
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
    
    // cliccando su ok viene creato l'oggetto report
    @IBAction func insertReport(_ sender: Any) {
        let context = AppDelegate.viewContext
        let report = Report(context: context)
        
        report.data = data!
        
		let itLocale = Locale(identifier: "it_IT")
		report.temperatura = NSDecimalNumber(string: temperatureField.text, locale: itLocale)
                 
        let pressioneMin = Int16(minPressureField.text!)
		report.pressioneMin = pressioneMin!
         
        
        let pressioneMax = Int16(maxPressureField.text!)
		report.pressioneMax = pressioneMax!
        
        let glicemia = Int16(glycemiaField.text!)
		report.glicemia = glicemia!
        
        let battito = Int16(heartRateField.text!)
		report.battito = battito!
        
        report.note = notesField.text
        
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
			notificationPublisher.sendNotification(title: "Report giornaliero", body: "Inserisci il tuo report odierno", badge: 1, sound: .default, day: dayCurrent+1 , hour: hour, minute: minute, id: "reportReminder", idAction: "posticipa", idTitle: "Posticipa")
        } catch {
            fatalError("Errore nel salvataggio: \(error)")
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
		okButton.isEnabled = false
	}


}
