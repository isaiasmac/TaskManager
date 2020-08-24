//
//  TaskCellView.swift
//  TaskManager
//
//  Created by Isaias on 21-08-20.
//  Copyright © 2020 IsaiasMac. All rights reserved.
//

import Cocoa

class TaskCellView: NSTableCellView {
    
    @IBOutlet weak var wrapperView: NSView!
    @IBOutlet weak var nameTextField: NSTextField!
    @IBOutlet weak var checkBox: NSButton!
    @IBOutlet weak var commentsTextField: NSTextField!
    @IBOutlet weak var labelTextField: NSTextField!
    
    override func awakeFromNib() {
        self.layer?.backgroundColor = .white
        wrapperView.wantsLayer = true
        
        wrapperView.layer?.backgroundColor = NSColor(calibratedRed: 0.97, green: 0.97, blue: 0.97, alpha: 1.0).cgColor
        wrapperView.layer?.cornerRadius = 6
        
        nameTextField.maximumNumberOfLines = 1
    }
    
    func setData(task: Task) {
        guard let title = task.title else { return }
        nameTextField.stringValue = title
        commentsTextField.stringValue = task.comments ?? ""
        labelTextField.stringValue = task.label ?? ""
        
        if task.status {
            checkBox.state = .on
        }
        else {
            checkBox.state = .off
        }
    }
}
