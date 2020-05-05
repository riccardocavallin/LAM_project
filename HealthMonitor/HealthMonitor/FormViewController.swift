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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func insertReport(_ sender: Any) {
        let temperatura = temperatureField.text
        let pressioneMin = minPressureField.text
        let pressioneMax = maxPressureField.text
        let glicemia = glycemiaField.text
        print("Temperatura: ", temperatura ?? "nessuna")
        print("Pressione min: ", pressioneMin ?? "nessuna")
        print("Pressione max: ", pressioneMax ?? "nessuna")
        print("Glicemia: ", glicemia ?? "nessuna")
        temperatureField.text = ""
        maxPressureField.text = ""
        minPressureField.text = ""
        glycemiaField.text = ""
    }



}
