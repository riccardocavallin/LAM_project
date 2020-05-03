//
//  FirstViewController.swift
//  HealthMonitor
//
//  Created by Riccardo Cavallin on 03/05/2020.
//  Copyright © 2020 Riccardo Cavallin. All rights reserved.
//

import FSCalendar
import UIKit

class FirstViewController: UIViewController, FSCalendarDelegate {
    
    @IBOutlet weak var calendar: FSCalendar!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        calendar.delegate = self;
    }

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE dd-MM-YYYY"
        let dataString = formatter.string(from:date)
        print("\(dataString)")
    }

}

