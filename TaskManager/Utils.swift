//
//  Utils.swift
//  TaskManager
//
//  Created by Isaias on 23-08-20.
//  Copyright © 2020 IsaiasMac. All rights reserved.
//

import Foundation

class Utils {
    
    static func date() -> (currentDay: Int, dayName: String, monthName: String, year: Int) {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let day = calendar.component(.day, from: date)
        let weekday = Calendar.current.component(.weekday, from: date)
        
        dateFormatter.dateFormat = "MMMM"
        let monthName = dateFormatter.string(from: date)
        let dayName = dateFormatter.weekdaySymbols[weekday-1]
        //print("year: \(year) - day: \(day) - monthName: \(monthName) - weekdayStr: \(dayName)")
        
        return (day, dayName, monthName, year)
    }
    
    
    static func save(appDelegate: AppDelegate) {
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            try context.save()
            debugPrint("Saved OK!")
        }
        catch {
            debugPrint("SAVE Error: \(error.localizedDescription)")
        }
    }
}
