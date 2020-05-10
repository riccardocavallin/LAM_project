//
//  SecondViewController.swift
//  HealthMonitor
//
//  Created by Riccardo Cavallin on 10/05/2020.
//  Copyright © 2020 Riccardo Cavallin. All rights reserved.
//

import UIKit
import CoreData
import Charts

class SecondViewController: UIViewController, ChartViewDelegate {
    
    @IBOutlet weak var temperatureChart: LineChartView!
    let context = AppDelegate.viewContext // per accedere al database
    var temperature : [NSDecimalNumber]? = nil
    var glicemia: [Int16]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
         if let dailyReports = findAllreports() {
            // recupero tutte le temperature e i parametri glicemia con il metodo map
            temperature = dailyReports.map{$0.temperatura!}
            glicemia = dailyReports.map{$0.glicemia}
            
            createTempChart()
        }
    }
    
    func createTempChart() {
        let yTemp = yValuesTemp(temperature: temperature!)
        let setTemp = LineChartDataSet(entries: yTemp, label: "Temperature")
        setTemp.drawCirclesEnabled = false
        setTemp.mode = .cubicBezier
        setTemp.lineWidth = 3
        setTemp.setColor(.white)
        setTemp.fill = Fill(color: .white)
        setTemp.fillAlpha = 0.3
        setTemp.drawFilledEnabled = true
        setTemp.drawHorizontalHighlightIndicatorEnabled = false
        setTemp.highlightColor = .green
        let dataTemp = LineChartData(dataSet: setTemp)
        dataTemp.setDrawValues(false)
        temperatureChart.data = dataTemp
        customizeTempChart()
    }
    
    func customizeTempChart() {
        temperatureChart.delegate = self
        temperatureChart.backgroundColor = #colorLiteral(red: 0.02720985375, green: 0.5578963757, blue: 0.9526826739, alpha: 0.6221362155)
        temperatureChart.rightAxis.enabled = false
        let asseY = temperatureChart.leftAxis
        asseY.labelFont = .boldSystemFont(ofSize: 12)
        asseY.setLabelCount(10, force: false)
        asseY.labelTextColor = .white
        asseY.axisLineColor = .white
        asseY.labelPosition = .outsideChart
        temperatureChart.xAxis.labelFont = .boldSystemFont(ofSize: 12)
        temperatureChart.xAxis.labelPosition = .bottom
        temperatureChart.xAxis.setLabelCount(4, force: false)
        temperatureChart.xAxis.labelTextColor = .white
        temperatureChart.xAxis.axisLineColor = .white
        temperatureChart.animate(xAxisDuration: 0.5)
        
    }
    // estraggo tutti i dati dal database
    func findAllreports() -> [Report]? {
        let request: NSFetchRequest<Report> = Report.fetchRequest()
        request.predicate = NSPredicate(value: true)
        // se fallisce restituisce nil
        return try? context.fetch(request)
    }
    
    // restituisce i dati delle temperature da plottare
    func yValuesTemp(temperature: [NSDecimalNumber?]) -> [ChartDataEntry] {
        var values = [ChartDataEntry]()
        for i in 0..<temperature.count {
            values.append(ChartDataEntry(x: Double(i), y: Double(truncating: temperature[i]!)))
        }
        return values
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }
    

}
