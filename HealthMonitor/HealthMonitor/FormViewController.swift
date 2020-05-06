//
//  FormViewController.swift
//  HealthMonitor
//
//  Created by Riccardo Cavallin on 05/05/2020.
//  Copyright © 2020 Riccardo Cavallin. All rights reserved.
//

import UIKit

class FormViewController: UIViewController {
    
    @IBOutlet weak var temperatureField: UITextField!
    @IBOutlet weak var minPressureField: UITextField!
    @IBOutlet weak var maxPressureField: UITextField!
    @IBOutlet weak var glycemiaField: UITextField!
    
    // variabile data passata dal FirstViewController
    var data = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func insertReport(_ sender: Any) {
        let itLocale = Locale(identifier: "it_IT")
        let temperatura = NSDecimalNumber(string: temperatureField.text, locale: itLocale)
        let pressioneMin = Int16(minPressureField.text!)
        let pressioneMax = Int16(maxPressureField.text!)
        let glicemia = Int16(glycemiaField.text!)
        print("Temperatura: ", temperatura)
        print("Pressione min: ", pressioneMin ?? "nessuna")
        print("Pressione max: ", pressioneMax ?? "nessuna")
        print("Glicemia: ", glicemia ?? "nessuna")
        print("Data: ", data)
        temperatureField.text = nil
        maxPressureField.text = nil
        minPressureField.text = nil
        glycemiaField.text = nil
        let context = AppDelegate.viewContext
        let report = Report(context: context)
        report.temperatura = temperatura
        report.pressioneMin = pressioneMax!
        report.pressioneMax = pressioneMax!
        report.glicemia = glicemia!
        

    }


}
