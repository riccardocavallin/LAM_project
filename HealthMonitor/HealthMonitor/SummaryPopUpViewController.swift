//
//  SummaryPopUpViewController.swift
//  HealthMonitor
//
//  Created by Riccardo Cavallin on 09/05/2020.
//  Copyright © 2020 Riccardo Cavallin. All rights reserved.
//

import Foundation
import UIKit

class SummaryPopUpViewController: UIViewController {
    
    @IBOutlet weak var reportLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var glycemiaLabel: UILabel!
    @IBOutlet weak var pMinLabel: UILabel!
    @IBOutlet weak var pMaxLabel: UILabel!
    @IBOutlet weak var heartRateLabel: UILabel!
    
    var reports: [Report]?
    lazy var temperatura : Decimal = 0
    let model = Retrieve()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabels()
    }
    
    @IBAction func closePopUp(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func setLabels() {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-YYYY"
        let data = formatter.string(from: reports![0].data!)
        reportLabel.text = "Valori medi del giorno " + data
        
        let temperatura = model.mediaTemperatura(reports: reports!)
        temperatureLabel.text = (temperatura != nil) ? "\(temperatura!)" : "N/A"
        
        let glicemia = model.mediaGlicemia(reports: reports!)
        glycemiaLabel.text = (glicemia != nil) ? "\(glicemia!)" : "N/A"
        
        let pMin = model.mediaPressioneMin(reports: reports!)
        pMinLabel.text = (pMin != nil) ? "\(pMin!)" : "N/A"
        
        let pMax = model.mediaPressioneMax(reports: reports!)
        pMaxLabel.text = (pMax != nil) ? "\(pMax!)" : "N/A"
        
        let battito = model.mediaBattito(reports: reports!)
        heartRateLabel.text = (battito != nil) ? "\(battito!)" : "N/A"

    }

}
