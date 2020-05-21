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
    @IBOutlet weak var tableView: UITableView!
    
    var pickerData = ["Tutti", "1","2","3","4","5"]
    let model = Retrieve()
    var reports : [Report]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        priorityPicker.delegate = self
        priorityPicker.dataSource = self
        infoTextArea.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100
        reports = model.findReports()
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
        let priority = row
        if row == 0 { // "Tutti"
            reports = model.findReports()
        } else {
            reports = model.findReportsByPriority(matching: priority)
        }
        self.tableView.reloadData()
    }
    
    @IBAction func tapInfo(_ sender: Any) {
        infoTextArea.isHidden = false
    }
    
}

extension FilterViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reports?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reportCell", for: indexPath) as! ReportCellWithDate
        if let report  = reports?[indexPath.row] {
            cell.setReport(index: indexPath.row + 1,report: report)
            return cell
        } else {
            return cell
        }
    }
    
    
}

// classe per le celle della tabella
class ReportCellWithDate: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tempInsLabel: UILabel!
    @IBOutlet weak var pMinInsLabel: UILabel!
    @IBOutlet weak var pMaxInsLabel: UILabel!
    @IBOutlet weak var glicInsLabel: UILabel!
    @IBOutlet weak var battitoInsLabel: UILabel!
    @IBOutlet weak var noteInsLabel: UILabel!
    
    
    func setReport(index: Int, report: Report) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-YYYY"
        let data = formatter.string(from: report.data!)
        dateLabel.text = "\(data)"
        dateLabel.lineBreakMode = .byWordWrapping
        dateLabel.numberOfLines = 0;

        if report.temperatura != nil && report.temperatura != 0 {
            tempInsLabel.text = "\(report.temperatura!)"
            tempInsLabel.textColor = .yellow
        } else {
            tempInsLabel.text = "N/A"
            tempInsLabel.textColor = .darkGray
        }
        
        if report.pressioneMin != 0 {
            pMinInsLabel.text = "\(report.pressioneMin)"
            pMinInsLabel.textColor = .yellow
        } else {
            pMinInsLabel.text = "N/A"
            pMinInsLabel.textColor = .darkGray
        }

        if report.pressioneMax != 0 {
            pMaxInsLabel.text = "\(report.pressioneMax)"
            pMaxInsLabel.textColor = .yellow
        } else {
            pMaxInsLabel.text = "N/A"
            pMaxInsLabel.textColor = .darkGray
        }

        if report.glicemia != 0 {
            glicInsLabel.text = "\(report.glicemia)"
            glicInsLabel.textColor = .yellow
        } else {
            glicInsLabel.text = "N/A"
            glicInsLabel.textColor = .darkGray
        }

        if report.battito != 0 {
            battitoInsLabel.text = "\(report.battito)"
            battitoInsLabel.textColor = .yellow
        } else {
            battitoInsLabel.text = "N/A"
            battitoInsLabel.textColor = .darkGray
        }

        if report.note != nil && !report.note!.isEmpty{
            noteInsLabel.text = "\(String(describing: report.note!))"
            noteInsLabel.textColor = .yellow
        } else {
            noteInsLabel.text = "N/A"
            noteInsLabel.textColor = .darkGray
        }

    }
    
}
