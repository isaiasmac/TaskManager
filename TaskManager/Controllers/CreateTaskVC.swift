//
//  CreateTaskVC.swift
//  TaskManager
//
//  Created by Isaias on 22-08-20.
//  Copyright © 2020 IsaiasMac. All rights reserved.
//

import Cocoa

protocol TaskProtocol {
    func didCreatedTask(_ task: Task)
}

class CreateTaskVC: NSViewController {

    @IBOutlet weak var titleTextField: NSTextField!
    @IBOutlet weak var descriptionTextField: NSTextField!
    @IBOutlet weak var emojisPopup: NSPopUpButton!
    
    var delegate: TaskProtocol?
    
    var dateSelected: Date?
    var context: NSManagedObjectContext?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var emojiList: [String] = []
        for i in 0x1F601...0x1F64F {
            emojiList.append(String(UnicodeScalar(i) ?? "-"))
        }
        
        emojisPopup.addItems(withTitles: emojiList)
        
    }
    
    @IBAction func cancelAction(_ sender: NSButton) {
        self.dismiss(nil)
    }
    
    @IBAction func saveAction(_ sender: NSButton) {
        let title = titleTextField.stringValue
        let description = descriptionTextField.stringValue
        var label: String? = "✍️"
        if emojisPopup.indexOfSelectedItem != 0 {
            label = emojisPopup.titleOfSelectedItem
        }
        
        if title.count < 3 {
            titleTextField.layer?.borderColor = NSColor.red.cgColor
            titleTextField.layer?.borderWidth = 1.0
            titleTextField.resignFirstResponder()
            return
        }
        
        let params: [String: Any] = ["title": title, "comments": description,
                                     "label": label ?? "✍️", "date": dateSelected!]
        let taskService = TaskService(self.context!)
        taskService.save(params) { task in
            self.delegate?.didCreatedTask(task)
            self.dismiss(nil)
        }
    }
    
    
}
