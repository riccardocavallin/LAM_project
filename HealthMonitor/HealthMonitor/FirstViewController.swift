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
	
	let model = Retrieve()
    var data: Date?
	var dailyReports : [Report]?
    let context = AppDelegate.viewContext // per accedere al database
	var schedule : Bool = true
	let defaults = UserDefaults.standard // variabile per accedere alle preferenze dell'utente
	private let notificationPublisher = NotificationPublisher()
	
    
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
		data = date
		// il bottone per agguingere report non viene mostrato per le date future
		if (data! < Date()) {
			aggiungiReport.isHidden = false
		} else {
			aggiungiReport.isHidden = true
		}
		dailyReports = model.findReportsByDay(matching: data!)
		if dailyReports?.count ?? 1 > 1 {
			summaryButton.isHidden = false
		} else {
			summaryButton.isHidden = true
		}
		self.tableView.reloadData()
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
			do {
				try self.context.save()
			} catch {
				fatalError("Errore nel salvataggio dopo l'eliminazione: \(error)")
			}
			// eliminazione dal vettore
			self.dailyReports?.remove(at: indexPath.row)
			// eliminazione dalla tabella
			self.tableView.deleteRows(at: [indexPath], with: .automatic)
			if self.dailyReports?.count == 0 {
				// se non ci sono più report devo rimettere la notifica per il giorno odierno
				let date = Date()
				let calendar = Calendar.current
				let dayCurrent = calendar.component(.day, from: date)
				let hour = self.defaults.integer(forKey: "oraNotificaReport")
				let minute = self.defaults.integer(forKey: "minutoNotificaReport")
				self.notificationPublisher.sendReportReminderNotification(title: "Report giornaliero", body: "Inserisci il tuo report odierno", badge: 1, sound: .default, day: dayCurrent , hour: hour, minute: minute, id: "reportReminder", idAction: "posticipa", idTitle: "Posticipa")
			}
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
		// vengono visualizzato solo i parametri diversi da 0
		indexLabel.text = "\(index)"
		if report.temperatura != 0 {
			tempInsLabel.text = "\(report.temperatura!)"
			tempInsLabel.textColor = .yellow
		}
		if report.pressioneMin > 0 {
			pMinInsLabel.text = "\(report.pressioneMin)"
			pMinInsLabel.textColor = .yellow
		}
		if report.pressioneMax > 0 {
			pMaxInsLabel.text = "\(report.pressioneMax)"
			pMaxInsLabel.textColor = .yellow
		}
		if report.glicemia > 0 {
			glicInsLabel.text = "\(report.glicemia)"
			glicInsLabel.textColor = .yellow
		}
		if report.battito > 0 {
			battitoInsLabel.text = "\(report.battito)"
			battitoInsLabel.textColor = .yellow
		}
		if report.note != nil {
			noteInsLabel.text = "\(String(describing: report.note!))"
			noteInsLabel.textColor = .yellow
		}
		
	}
	
	
}



