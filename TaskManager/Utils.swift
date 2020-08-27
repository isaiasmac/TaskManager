//
//  Utils.swift
//  TaskManager
//
//  Created by Isaias on 23-08-20.
//  Copyright © 2020 IsaiasMac. All rights reserved.
//

import Foundation


class Utils {
    
    
    // https://nsdateformatter.com
    static func dateFormatted(dateFormatter: DateFormatter, _ date: Date = Date()) -> (dateStr: String, date: Date) {
        let dateFormatter = dateFormatter
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "E dd, MMM yyyy"
        dateFormatter.isLenient = true
        let dateStr = dateFormatter.string(from: date)
        let dateObj = dateFormatter.date(from: dateStr)
        print("DateStr: \(dateStr) - Date: \(dateObj!)")
        return (dateStr, dateObj!)
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
    
    static func dateCurrentTimeZone(dateFormatter: DateFormatter, date: Date = Date()) -> Date {
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        let dString = dateFormatter.string(from: date)        
        dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC")!
//        let d = dateFormatter.date(from: dString)!
//        debugPrint("######-date-#######")
//        debugPrint(d)
//        debugPrint("#####./-date-#######")
        return dateFormatter.date(from: dString)!
    }
    
    static func dayFromDate(date: Date) -> Int32 {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        if let day = calendar.dateComponents([.day], from: date).day {
            return Int32(day)
        }
        return Int32(0)
    }
    
    static func dateSimpleFormat(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC")!
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
}
