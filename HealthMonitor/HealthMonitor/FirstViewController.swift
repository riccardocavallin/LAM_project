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
    @IBOutlet weak var tableView: UITableView!
    
    var data: String? = nil
	var dailyReports : [Report]? = nil
    let context = AppDelegate.viewContext // per accedere al database
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        aggiungiReport.isHidden = true
        findAllreports()
    }
    
	// trovo tutti i report e li stampo
	func findAllreports() {
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
	
	// cliccando sul giorno salva la data corrispondente e aggiorna i report visualizzati
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-YYYY"
        data = formatter.string(from:date)
        aggiungiReport.isHidden = false
		dailyReports = findReportsByDay(matching: data!)
		self.tableView.reloadData()
	}
	
	// ritorna tutti i report con la data selezionata
	func findReportsByDay(matching data:String) -> [Report]? {
		let request: NSFetchRequest<Report> = Report.fetchRequest()
		request.predicate = NSPredicate(format: "data = %@", data)
		return try? context.fetch(request)
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

// estensione con metodi di gestione della tabella
extension FirstViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tapped")
    }
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return dailyReports?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "reportCell", for: indexPath) as! ReportTableViewCell
		if let report  = dailyReports?[indexPath.row] {
			cell.setReport(index: indexPath.row + 1,report: report)
			return cell
		} else {
			return cell
		}
    }
    
}

// classe per le celle della tabella
class ReportTableViewCell: UITableViewCell {

	@IBOutlet weak var indexLabel: UILabel!
	@IBOutlet weak var tempInsLabel: UILabel!
	@IBOutlet weak var pMinInsLabel: UILabel!
	@IBOutlet weak var pMaxInsLabel: UILabel!
	@IBOutlet weak var glicInsLabel: UILabel!
	@IBOutlet weak var battitoInsLabel: UILabel!
	@IBOutlet weak var noteInsLabel: UILabel!
	
	
	func setReport(index: Int, report: Report) {
		indexLabel.text = "\(index)"
		if tempInsLabel.text != nil {
			tempInsLabel.text = "\(String(describing: report.temperatura))"
		} else {
			tempInsLabel.text = "N/A"
		}
		pMinInsLabel.text = "\(report.pressioneMin)"
		pMaxInsLabel.text = "\(report.pressioneMax)"
		glicInsLabel.text = "\(report.glicemia)"
		battitoInsLabel.text = "\(report.battito)"
		noteInsLabel.text = "\(String(describing: report.note))"
		
		
	}
	
	
}


