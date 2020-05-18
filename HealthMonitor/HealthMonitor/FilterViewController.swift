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
    
    var pickerData = ["1","2","3","4","5"]
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
        let priority = row + 1
        reports = model.findReportsByPriority(matching: priority)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "reportCell", for: indexPath) as! ReportTableViewCell
        if let report  = reports?[indexPath.row] {
            cell.setReport(index: indexPath.row + 1,report: report)
            return cell
        } else {
            return cell
        }
    }
    
    
}
