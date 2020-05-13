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
    
    // restituisce tutti i report
    private func findReports() -> [Report]? {
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
    
}
