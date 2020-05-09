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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabels()
    }
    
    @IBAction func closePopUp(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func setLabels() {
        reportLabel.text = "Giorno " + reports![0].data!
        for report in reports! {
            temperatura = (report.temperatura! as Decimal) + temperatura
        }
        temperatureLabel.text = "\(temperatura / (Decimal(reports!.count)))"
        let glicemia = (reports?.reduce(0, {$0 + $1.glicemia}))! / Int16(reports!.count)
        glycemiaLabel.text = "\(glicemia)"
        let pressioneMin = (reports?.reduce(0, {$0 + $1.pressioneMin}))! / Int16(reports!.count)
        pMinLabel.text = "\(pressioneMin)"
        let pressioneMax = (reports?.reduce(0, {$0 + $1.pressioneMax}))! / Int16(reports!.count)
        pMaxLabel.text = "\(pressioneMax)"
        let battito = (reports?.reduce(0, {$0 + $1.battito}))! / Int16(reports!.count)
        heartRateLabel.text = "\(battito)"
    }

}
