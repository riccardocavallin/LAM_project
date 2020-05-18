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
        
        temperatureLabel.text = "\(model.mediaTemperatura(reports: reports!))"
        
        glycemiaLabel.text = "\(model.mediaGlicemia(reports: reports!))"
        
        pMinLabel.text = "\(model.mediaPressioneMin(reports: reports!))"
        
        pMaxLabel.text = "\(model.mediaPressioneMax(reports: reports!))"
        
        heartRateLabel.text = "\(model.mediaBattito(reports: reports!))"
    }

}
