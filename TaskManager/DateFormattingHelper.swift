//
//  DateFormattingHelper.swift
//  TaskManager
//
//  Created by Isaias on 25-08-20.
//  Copyright © 2020 IsaiasMac. All rights reserved.
//

import Foundation

class DateFormattingHelper {

    // MARK: - Shared

    static let shared = DateFormattingHelper()

    // MARK: - Formatters

    let dobDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter
    }()
}
