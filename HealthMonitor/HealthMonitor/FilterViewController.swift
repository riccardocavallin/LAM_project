//
//  FilterViewController.swift
//  HealthMonitor
//
//  Created by Riccardo Cavallin on 18/05/2020.
//  Copyright © 2020 Riccardo Cavallin. All rights reserved.
//

import Foundation
import UIKit

class FilterViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var priorityPicker: UIPickerView!
    @IBOutlet weak var infoTextArea: UITextView!
    
    var pickerData = ["1","2","3","4","5"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.priorityPicker.delegate = self
        self.priorityPicker.dataSource = self
        infoTextArea.isHidden = true
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
        print("Ciao")
        
    }
    
    @IBAction func tapInfo(_ sender: Any) {
        infoTextArea.isHidden = false
    }
    
    
}
