//
//  TasksListVC.swift
//  TaskManager
//
//  Created by Isaias on 21-08-20.
//  Copyright © 2020 IsaiasMac. All rights reserved.
//

import Cocoa

class TasksListVC: NSViewController {
    
    @IBOutlet weak var dayNumberTextField: NSTextField!
    @IBOutlet weak var dayNameTextField: NSTextField!
    @IBOutlet weak var monthNameAndYearTextField: NSTextField!
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var nsBox: NSBox!
    @IBOutlet weak var emptyMessageTextField: NSTextField!
    
    lazy var context: NSManagedObjectContext = {
        let appDelegate = NSApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }()
    
    
    var tasks: [Task] = [] {
        didSet {
            if tasks.count <= 0 {
                emptyMessageTextField.isHidden = false
                tableView.isHidden = true
            }
            else {
                emptyMessageTextField.isHidden = true
                tableView.isHidden = false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.usesAlternatingRowBackgroundColors = false
        tableView.backgroundColor = .white
        
        emptyMessageTextField.isHidden = true
        
        self.nsBox.fillColor = NSColor(calibratedRed: 1.00, green: 0.80, blue: 0.00, alpha: 1.00)
        
        fetchTasks()
        
        let date = Utils.date()
        dayNumberTextField.stringValue = "\(date.currentDay)"
        dayNameTextField.stringValue = "\(date.dayName)"
        monthNameAndYearTextField.stringValue = "\(date.monthName), \(date.year)"
    }
    
    
    private func fetchTasks() {
        let appDelegate = NSApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        do {
            let result = try context.fetch(fetchRequest)
            self.tasks = result
            self.tableView.reloadData()
        }
        catch {
            debugPrint("Fetch Error: \(error.localizedDescription)")
        }
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToCreateTask" {
            let createTaskVC = segue.destinationController as! CreateTaskVC
            createTaskVC.delegate = self
        }
    }
    
    @objc func handleCheck(_ sender: NSButton) {
        let row = sender.tag
        let task = self.tasks[row]
        if sender.state == .on {
            task.status = true
        }
        else {
            task.status = false
        }
        
        do {
            try context.save()
            debugPrint("Saved OK! ## task: \(task.status)")
        }
        catch {
            debugPrint("SAVE Error: \(error.localizedDescription)")
        }
        
        self.tableView.reloadData()
    }
}

extension TasksListVC: TaskProtocol {
    func didCreatedTask(task: Task) {
        self.tasks.append(task)
        self.tableView.reloadData()
    }
    
}

extension TasksListVC: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.tasks.count
    }
    
}

extension TasksListVC: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cellView = tableView.makeView(withIdentifier: tableColumn!.identifier, owner: self) as! TaskCellView
        
        let task = self.tasks[row]
        cellView.setData(task: task)
        cellView.checkBox.tag = row
        cellView.checkBox.action = #selector(handleCheck(_ :))
        
        return cellView
    }
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        false
    }
    
}
