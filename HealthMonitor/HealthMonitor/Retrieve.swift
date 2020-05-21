//
//  Retrieve.swift
//  HealthMonitor
//
//  Created by Riccardo Cavallin on 13/05/2020.
//  Copyright © 2020 Riccardo Cavallin. All rights reserved.
//

import Foundation
import CoreData

class Retrieve {
    
    let context = AppDelegate.viewContext // per accedere al database
    // variabile per accedere alle preferenze dell'utente
    private let defaults = UserDefaults.standard
    
    // restituisce tutti i report
    func findReports() -> [Report]? {
        let request: NSFetchRequest<Report> = Report.fetchRequest()
        request.predicate = NSPredicate(value: true)
        // filtrati in ordine di inserimento
        request.sortDescriptors = [NSSortDescriptor(key: "data", ascending: true)]
        return try? context.fetch(request)
    }
    
    // ritorna tutti i report con la data selezionata
    func findReportsByDay(matching data:Date) -> [Report]? {
        let request: NSFetchRequest<Report> = Report.fetchRequest()
        request.predicate = NSPredicate(format: "data = %@", data as NSDate)
        // filtrati in ordine di inserimento
        request.sortDescriptors = [NSSortDescriptor(key: "data", ascending: true)]
        return try? context.fetch(request)
    }
    
    // estraggo tutti i report dell'ultima settimana
    func findLastWeekReports() -> [Report]? {
        let today = NSDate()
        let aWeekAgo = today.addingTimeInterval(-7*24*60*60)
        let request: NSFetchRequest<Report> = Report.fetchRequest()
        // estraggo solo i report dell'ultima settimana
        request.predicate = NSPredicate(format: "data > %@ AND data < %@", aWeekAgo, today)
        // ordinamento per data
        request.sortDescriptors = [NSSortDescriptor(key: "data", ascending: true)]
        // se fallisce restituisce nil
        return try? context.fetch(request)
    }
    
    // ritorna tutti i report con una data priorità
    func findReportsByPriority(matching priorita:Int) -> [Report]? {
        let reports = findReports()
        let filtered = reports?.filter{$0.priorita == priorita}
        return filtered
    }
    
    //funzione che ritorna la media degli ultimi x giorni di un dato parametro
    func media(parametro: Int) -> Any? {
        let result: Any?
        // calcolo della data di partenza per estrarre i dati
        let durata = defaults.integer(forKey: "durata")
        let scadenza = defaults.object(forKey: "scadenza") as! Date
        let parametro = defaults.integer(forKey: "parametro")
        var dateComponent = DateComponents()
        dateComponent.day = -durata
        // la data di partenza è la scadenza (oggi) - la durata
        let partenza = Calendar.current.date(byAdding: dateComponent, to: scadenza)
        // estraggo tutti i report dell'ultima settimana
        let request: NSFetchRequest<Report> = Report.fetchRequest()
        request.predicate = NSPredicate(format: "data > %@ AND data < %@", partenza! as NSDate, scadenza as NSDate)
        let reports = try! context.fetch(request)
        
        // calcolo la media adeguata in base al parametro da monitorare
        switch parametro {
        case 0:
            result = mediaTemperatura(reports: reports)
        case 1:
            result =  mediaPressioneMin(reports: reports)
        case 2:
            result = mediaPressioneMax(reports: reports)
        case 3:
            result = mediaGlicemia(reports: reports)
        case 4:
            result = mediaBattito(reports: reports)
        default:
            print("default case")
            result = nil
        }
        
        return result
    }
    
    func mediaTemperatura(reports: [Report]) -> Decimal? {
        var count = 0
        var temperatura : Decimal = 0
        for report in reports {
            if (report.temperatura! as Decimal) != 0 {
                temperatura = (report.temperatura! as Decimal) + temperatura
                count += 1
            }
        }
        return (count > 0) ? temperatura / Decimal(count) : nil
    }
    
    // conto quante volte è stata inseita la glicemia (cioè quante volte è > 0)
    func mediaGlicemia(reports: [Report]) -> Int? {
        //let glicemia = (reports?.filter{$0.glicemia > 0}.reduce(0, {$0 + $1.glicemia}))! / countGlicemia
        let count = Int16(reports.filter({ $0.glicemia > 0 }).count)
        return (count > 0) ? Int((reports.reduce(0, {$0 + $1.glicemia})) / count) : nil
    }
    
    func mediaPressioneMin(reports: [Report]) -> Int? {
        let count = Int16(reports.filter({ $0.pressioneMin > 0 }).count)
        return (count > 0) ? Int((reports.reduce(0, {$0 + $1.pressioneMin})) / count) : nil
    }
    
    func mediaPressioneMax(reports: [Report]) -> Int? {
        let count = Int16(reports.filter({ $0.pressioneMax > 0 }).count)
        return (count > 0) ? Int((reports.reduce(0, {$0 + $1.pressioneMax})) / count) : nil
    }
    
    func mediaBattito(reports: [Report]) -> Int? {
        let count = Int16(reports.filter({ $0.battito > 0 }).count)
        return (count > 0) ? Int((reports.reduce(0, {$0 + $1.battito})) / count) : nil
    }
    
}
