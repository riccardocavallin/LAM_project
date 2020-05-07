//
//  FirstViewController.swift
//  HealthMonitor
//
//  Created by Riccardo Cavallin on 03/05/2020.
//  Copyright © 2020 Riccardo Cavallin. All rights reserved.
//

import FSCalendar
import UIKit
import CoreData

class FirstViewController: UIViewController, FSCalendarDelegate {
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var aggiungiReport: UIButton!
    
    var data: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.delegate = self
        aggiungiReport.isHidden = true
        let context = AppDelegate.viewContext
        let request: NSFetchRequest<Report> = Report.fetchRequest()
        request.predicate = NSPredicate(value: true)
        // se fallisce restituisce nil
        let allReports = try? context.fetch(request)
        if allReports != nil {
            for report in allReports! {
                print("restituito report \(report.data!)")
            }
        }
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-YYYY"
        data = formatter.string(from:date)
        aggiungiReport.isHidden = false
        
    }
    
    // funzione che permette di passare la data alla view del form passando la data selezionata
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let formVC = segue.destination as! FormViewController
        formVC.data = data

    }
    
    // cliccando su aggiungi report si passa alla nuova view
    @IBAction func aggiungiReportClicked(_ sender: Any) {
         performSegue(withIdentifier: "showReport", sender: self)
    }

}

