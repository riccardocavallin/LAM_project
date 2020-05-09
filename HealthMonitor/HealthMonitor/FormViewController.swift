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
    
    // variabile data passata dal FirstViewController
    var data: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // cliccando su ok viene creato l'oggetto report
    @IBAction func insertReport(_ sender: Any) {
        let context = AppDelegate.viewContext
        let report = Report(context: context)
        
        report.data = data!
        
        if temperatureField.text != ""  {
            let itLocale = Locale(identifier: "it_IT")
            report.temperatura = NSDecimalNumber(string: temperatureField.text, locale: itLocale)
            //print("Temperatura: ", report.temperatura ?? "nessuna")
        }
        
        let pressioneMin = Int16(minPressureField.text!)
        if minPressureField.text != ""  && pressioneMin != nil {
          report.pressioneMin = pressioneMin!
            //print("Pressione min: ", report.pressioneMin )
        }
        
        let pressioneMax = Int16(maxPressureField.text!)
        if maxPressureField.text != ""  && pressioneMax != nil {
            report.pressioneMax = pressioneMax!
            //print("Pressione max: ", report.pressioneMax )
        }
        
        let glicemia = Int16(glycemiaField.text!)
        if glycemiaField.text != ""  && glicemia != nil {
            report.glicemia = glicemia!
            //print("Glicemia: ", report.glicemia )
        }
        
        let battito = Int16(heartRateField.text!)
        if heartRateField.text != ""  && battito != nil {
            report.battito = battito!
            //print("Battito: ", report.battito )
        }
        
        report.note = notesField.text
        //print("Note: ", report.note ?? "nessuna")
        
		resetLabels()
        
        // salvataggio nel database
        do {
            try context.save()
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
	}


}
