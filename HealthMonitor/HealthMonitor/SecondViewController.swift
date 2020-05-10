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
    @IBOutlet weak var glycemiaChart: BarChartView!
    
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
            createGlycemChart()
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
        //dataTemp.setDrawValues(false)
        temperatureChart.data = dataTemp
        customizeTempChart()
    }
    
    func customizeTempChart() {
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
    
    func createGlycemChart() {
        let yGlicem = yValuesGlycem(glicemia: glicemia!)
        let setGlicem = BarChartDataSet(entries: yGlicem, label: "Glicemia")
        setGlicem.setColor(#colorLiteral(red: 0.08594541997, green: 0.757057488, blue: 0.07849871367, alpha: 0.8329179448))
        setGlicem.highlightColor = .yellow
        let dataGlicem = BarChartData(dataSet: setGlicem)
        glycemiaChart.data = dataGlicem
        customizeGlicemChart()
    }
    
    func customizeGlicemChart() {
        glycemiaChart.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 0.6933833397)
        glycemiaChart.rightAxis.enabled = false
        let asseY = glycemiaChart.leftAxis
        asseY.labelFont = .boldSystemFont(ofSize: 12)
        asseY.setLabelCount(10, force: false)
        asseY.labelTextColor = .white
        asseY.axisLineColor = .white
        asseY.labelPosition = .outsideChart
        glycemiaChart.xAxis.labelFont = .boldSystemFont(ofSize: 12)
        glycemiaChart.xAxis.labelPosition = .bottom
        glycemiaChart.xAxis.setLabelCount(4, force: false)
        glycemiaChart.xAxis.labelTextColor = .white
        glycemiaChart.xAxis.axisLineColor = .white
        glycemiaChart.animate(xAxisDuration: 0.5)
    }
    
    // estraggo tutti i dati dal database
    func findAllreports() -> [Report]? {
        let request: NSFetchRequest<Report> = Report.fetchRequest()
        request.predicate = NSPredicate(value: true)
        // se fallisce restituisce nil
        return try? context.fetch(request)
    }
    
    // converte i dati della glicemia nel formato giusto per plottarli
    func yValuesTemp(temperature: [NSDecimalNumber?]) -> [ChartDataEntry] {
        var values = [ChartDataEntry]()
        for i in 0..<temperature.count {
            values.append(ChartDataEntry(x: Double(i), y: Double(truncating: temperature[i]!)))
        }
        return values
    }
    
    // converte i dati della glicemia nel formato giusto per plottarli
    func yValuesGlycem(glicemia: [Int16?]) -> [BarChartDataEntry] {
        var values = [BarChartDataEntry]()
        for i in 0..<glicemia.count {
            values.append(BarChartDataEntry(x: Double(i), y: Double(glicemia[i]!)))
        }
        return values
    }
    

}
