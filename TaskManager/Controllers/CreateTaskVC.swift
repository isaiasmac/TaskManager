//
//  CreateTaskVC.swift
//  TaskManager
//
//  Created by Isaias on 22-08-20.
//  Copyright © 2020 IsaiasMac. All rights reserved.
//

import Cocoa

protocol TaskProtocol {
    func didCreatedTask(task: Task)
}

class CreateTaskVC: NSViewController {

    @IBOutlet weak var titleTextField: NSTextField!
    @IBOutlet weak var descriptionTextField: NSTextField!
    @IBOutlet weak var emojisPopup: NSPopUpButton!
    
    private let manager = CoreDataManager()
    
    var delegate: TaskProtocol?
    
    
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
        print("\(#function)")
        
        
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
        
        let appDelegate = NSApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let task = Task(context: context)
        task.title = title
        task.comments = description
        task.label = label
        task.created = Date()
        
        do {
            try context.save()
            debugPrint("Saved OK!")
            self.delegate?.didCreatedTask(task: task)
            self.dismiss(nil)
        }
        catch {
            debugPrint("SAVE Error: \(error.localizedDescription)")
        }
        
//        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
//        do {
//            let result = try context.fetch(fetchRequest)
//            debugPrint(result)
//        }
//        catch {
//            debugPrint("Fetch Error: \(error.localizedDescription)")
//        }
        
    }
    
    
}
