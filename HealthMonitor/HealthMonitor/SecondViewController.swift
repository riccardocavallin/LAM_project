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
    
    private let context = AppDelegate.viewContext // per accedere al database
    private var temperature : [NSDecimalNumber]? = nil
    private var glicemia: [Int16]?
    let model = Retrieve()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addStyle()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if let dailyReports = model.findLastWeekReports() {
            // recupero tutte le temperature e i parametri glicemia con il metodo map e le filtro
            temperature = dailyReports.map{$0.temperatura!}.filter{$0 != 0}
            glicemia = dailyReports.map{$0.glicemia}.filter{$0 != 0}
            
            createTempChart()
            createGlycemChart()
        }
    }
    
    // stile grafico per i grafici
    private func addStyle() {
        temperatureChart.layer.shadowColor = UIColor.white.cgColor
        temperatureChart.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        temperatureChart.layer.shadowRadius = 15.0
        temperatureChart.layer.shadowOpacity = 0.5
        temperatureChart.layer.cornerRadius = 15.0
        temperatureChart.clipsToBounds = true
        glycemiaChart.layer.shadowColor = UIColor.white.cgColor
        glycemiaChart.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        glycemiaChart.layer.shadowRadius = 15.0
        glycemiaChart.layer.shadowOpacity = 0.9
        glycemiaChart.layer.cornerRadius = 15.0
        glycemiaChart.clipsToBounds = true
    }
    
    private func createTempChart() {
        let yTemp = yValuesTemp(temperature: temperature!)
        let setTemp = LineChartDataSet(entries: yTemp, label: "Temperatura nell'ultima settimana")
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
    
    private func customizeTempChart() {
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
    
    private func createGlycemChart() {
        let yGlicem = yValuesGlycem(glicemia: glicemia!)
        let setGlicem = BarChartDataSet(entries: yGlicem, label: "Glicemia nell'ultima settimana")
        setGlicem.setColor(#colorLiteral(red: 0.08594541997, green: 0.757057488, blue: 0.07849871367, alpha: 0.8329179448))
        setGlicem.highlightColor = .yellow
        let dataGlicem = BarChartData(dataSet: setGlicem)
        glycemiaChart.data = dataGlicem
        customizeGlicemChart()
    }
    
    private func customizeGlicemChart() {
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
    
    // converte i dati della glicemia nel formato giusto per plottarli
    private func yValuesTemp(temperature: [NSDecimalNumber?]) -> [ChartDataEntry] {
        var values = [ChartDataEntry]()
        for i in 0..<temperature.count {
            values.append(ChartDataEntry(x: Double(i), y: Double(truncating: temperature[i]!)))
        }
        return values
    }
    
    // converte i dati della glicemia nel formato giusto per plottarli
    private func yValuesGlycem(glicemia: [Int16?]) -> [BarChartDataEntry] {
        var values = [BarChartDataEntry]()
        for i in 0..<glicemia.count {
            values.append(BarChartDataEntry(x: Double(i), y: Double(glicemia[i]!)))
        }
        return values
    }
    

}
