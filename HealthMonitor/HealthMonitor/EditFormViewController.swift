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
        if let _ = report?.temperatura  {
            print("\(report!.temperatura!)")
            temperatureField.text = "\(report!.temperatura!)"
        }
        if let _ = report?.pressioneMin  {
            minPressureField.text = "\(report!.pressioneMin)"
        }
        if let _ = report?.pressioneMax {
           maxPressureField.text = "\(report!.pressioneMax)"
        }
        if let _ = report?.glicemia {
           glycemiaField.text = "\(report!.glicemia)"
        }
        if let _ = report?.battito {
            heartRateField.text = "\(report!.battito)"
        }
        if let _ = report?.note {
           notesField.text = "\(report!.note!)"
        }
        
    }
    
    @IBAction func updateReport(_ sender: Any) {
        
        let context = AppDelegate.viewContext
        
        if temperatureField.text != ""  {
            let itLocale = Locale(identifier: "it_IT")
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
