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
    
    var data = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func insertReport(_ sender: Any) {
        let temperatura = temperatureField.text
        let pressioneMin = minPressureField.text
        let pressioneMax = maxPressureField.text
        let glicemia = glycemiaField.text
//        let date = Date()
//        let formatter = DateFormatter()
//        let dataString = formatter.string(from:date)
//        formatter.dateFormat = "EEEE dd-MM-YYYY"
        print("Temperatura: ", temperatura ?? "nessuna")
        print("Pressione min: ", pressioneMin ?? "nessuna")
        print("Pressione max: ", pressioneMax ?? "nessuna")
        print("Glicemia: ", glicemia ?? "nessuna")
        print("Data: ", data)
        temperatureField.text = ""
        maxPressureField.text = ""
        minPressureField.text = ""
        glycemiaField.text = ""
    }


}
