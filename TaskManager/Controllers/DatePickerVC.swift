//
//  DatePickerVC.swift
//  TaskManager
//
//  Created by Isaias on 24-08-20.
//  Copyright © 2020 IsaiasMac. All rights reserved.
//

import Cocoa

protocol DatePickerProtocol {
    func didSelectedDate(date: Date)
}

class DatePickerVC: NSViewController, NSDatePickerCellDelegate {

    @IBOutlet weak var datePicker: NSDatePicker!
    var delegate: DatePickerProtocol?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.timeZone = TimeZone.current
        datePicker.dateValue = Date()
        
        datePicker.target = self
        datePicker.action = #selector(dateSelected)

        let action = NSEvent.EventTypeMask.mouseExited
        self.datePicker.sendAction(on: action)
    }
    
    
    @objc func dateSelected() {
        let dateSelected = datePicker.dateValue
        self.delegate?.didSelectedDate(date: dateSelected)
        self.dismiss(nil)
    }
    
    
}
