//
//  FirstViewController.swift
//  HealthMonitor
//
//  Created by Riccardo Cavallin on 03/05/2020.
//  Copyright © 2020 Riccardo Cavallin. All rights reserved.
//

import FSCalendar
import UIKit

class FirstViewController: UIViewController, FSCalendarDelegate {
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var aggiungiReport: UIButton!
    
    var dataString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.delegate = self
        aggiungiReport.isHidden = true
    }
    
//    func showAggiungiReportButton() {
//        if (dataString == "") {
//            aggiungiReport.isHidden = true
//        } else {
//            aggiungiReport.isHidden = false
//        }
//    }

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE dd-MM-YYYY"
        dataString = formatter.string(from:date)
        print("\(dataString)")
        aggiungiReport.isHidden = false
        
    }
    
    // funzione che permette di passare la data alla view del form passando la data selezionata
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let formVC = segue.destination as! FormViewController
        formVC.data = dataString

    }
    
    // cliccando su aggiungi report si passa alla nuova view
    @IBAction func aggiungiReportClicked(_ sender: Any) {
         performSegue(withIdentifier: "showReport", sender: self)
    }

}

