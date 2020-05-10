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
	@IBOutlet weak var summaryButton: UIButton!
	
    var data: Date?
	var dailyReports : [Report]?
    let context = AppDelegate.viewContext // per accedere al database
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        aggiungiReport.isHidden = true
		summaryButton.isHidden = true
		tableView.rowHeight = 100
    }
	
	// cliccando sul giorno salva la data corrispondente e aggiorna i report visualizzati
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        //let formatter = DateFormatter()
        //formatter.dateFormat = "dd-MM-YYYY"
        //data = formatter.string(from:date)
		data = date
		aggiungiReport.isHidden = false
		dailyReports = findReportsByDay(matching: data!)
		if dailyReports?.count ?? 1 > 1 {
			summaryButton.isHidden = false
		} else {
			summaryButton.isHidden = true
		}
		self.tableView.reloadData()
	}
	
	// ritorna tutti i report con la data selezionata
	func findReportsByDay(matching data:Date) -> [Report]? {
		let request: NSFetchRequest<Report> = Report.fetchRequest()
		request.predicate = NSPredicate(format: "data = %@", data as NSDate)
		// filtrati in ordine di inserimento
		request.sortDescriptors = [NSSortDescriptor(key: "data", ascending: true)]
		return try? context.fetch(request)
	}
	    
    // funzione che permette di passare la data alla view del form passando la data selezionata
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let identifier = segue.identifier {
			switch identifier {
			case "showReport":
				let formVC = segue.destination as! FormViewController
				formVC.data = data
			case "editReport":
				let editFormVC = segue.destination as! EditFormViewController
				let row = tableView.indexPathForSelectedRow!.row
				editFormVC.report = dailyReports![row]
			case "showSummary":
				let summaryVC = segue.destination as! SummaryPopUpViewController
				summaryVC.reports = dailyReports!
			default:
				print("Identifier non valido")
			}
		}

    }
    
    // cliccando su aggiungi report si passa alla nuova view
    @IBAction func aggiungiReportClicked(_ sender: Any) {
         performSegue(withIdentifier: "showReport", sender: self)
    }
    
}

// estensione con metodi di gestione della tabella
extension FirstViewController: UITableViewDelegate, UITableViewDataSource {
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//		//performSegue(withIdentifier: "editReport", sender: self)
//    }
    
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
	
	func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
		let action = UIContextualAction(style: .destructive, title: "Elimina") { (action, view, completion) in
			// eliminazione dal database
			self.context.delete(self.dailyReports![indexPath.row])
			// eliminazione dal vettore
			self.dailyReports?.remove(at: indexPath.row)
			// eliminazione dalla tabella
			self.tableView.deleteRows(at: [indexPath], with: .automatic)
			completion(true)
		}
		action.backgroundColor = .red
		return action
	}
	
	func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let delete = deleteAction(at: indexPath)
		return UISwipeActionsConfiguration(actions: [delete])
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
			tempInsLabel.text = "\(report.temperatura!)"
		}
		pMinInsLabel.text = "\(report.pressioneMin)"
		pMaxInsLabel.text = "\(report.pressioneMax)"
		glicInsLabel.text = "\(report.glicemia)"
		battitoInsLabel.text = "\(report.battito)"
		noteInsLabel.text = "\(report.note!)"
		
		
	}
	
	
}


