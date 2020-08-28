//
//  TasksListVC.swift
//  TaskManager
//
//  Created by Isaias on 21-08-20.
//  Copyright © 2020 IsaiasMac. All rights reserved.
//

import Cocoa


class TasksListVC: NSViewController {
    
    @IBOutlet weak var dateButton: NSButton!
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var nsBox: NSBox!
    @IBOutlet weak var emptyMessageTextField: NSTextField!
    var dateSelected: Date!
    let appDelegate = NSApplication.shared.delegate as! AppDelegate
    
    lazy var context: NSManagedObjectContext = {
        return appDelegate.persistentContainer.viewContext
    }()
    
    lazy var taskService: TaskService = {
        return TaskService(context)
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
        
        self.dateSelected = Utils.dateCurrentTimeZone(dateFormatter: appDelegate.dateFormatter)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.usesAlternatingRowBackgroundColors = false
        tableView.backgroundColor = .clear
        
        emptyMessageTextField.isHidden = true
        
        //self.nsBox.fillColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        let df = Utils.dateFormatted(dateFormatter: appDelegate.dateFormatter, self.dateSelected)
        setDateButton(dateStr: df.dateStr)
        
        fetchTasks()
    }
    
    func fetchTasks() {
        taskService.fetch(date: dateSelected!) { tasks in
            self.tasks = tasks
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToCreateTask" {
            let createTaskVC = segue.destinationController as! CreateTaskVC
            createTaskVC.delegate = self
            createTaskVC.dateSelected = self.dateSelected
            createTaskVC.context = self.context
        }
        else if segue.identifier == "segueToDatePicker" {
            let datePickerVC = segue.destinationController as! DatePickerVC
            datePickerVC.delegate = self
        }
    }
    
    @objc func handleCheck(_ sender: NSButton) {
        let row = sender.tag
        let task = self.tasks[row]
        
        if sender.state == .on { task.status = true }
        else { task.status = false }
        
        taskService.update(task: task) {
            self.tableView.reloadData()
        }
    }
    
    func deleteTask(_ row: Int) {
        let task = self.tasks[row]
        
        taskService.delete(task: task) {
            self.tasks.remove(at: row)
            self.tableView.reloadData()
        }
    }
    
    func setDateButton(dateStr: String) {
        DispatchQueue.main.async {
            self.dateButton.title = dateStr
        }
        fetchTasks()
    }
    
    @IBAction func moveDateAction(_ sender: NSButton) {
        let tag = sender.tag
        var delay: Int = 1 // forward
        
        if tag == 0 { // back
            delay = -1
        }
        
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        calendar.locale = Locale.current
        if let date = calendar.date(byAdding: .day, value: delay, to: dateSelected) {
            self.dateSelected = date
            let df = Utils.dateFormatted(dateFormatter: appDelegate.dateFormatter, date)
            //debugPrint("moveDateAction => \(date) - moveDateAction (2) => \(df.dateStr)")
            setDateButton(dateStr: df.dateStr)
        }
        else {
            debugPrint("\(#function) NOT DAY ADDED.")
            fatalError("ERROR ====================>")
        }
    }
}

extension TasksListVC: TaskProtocol {
    func didCreatedTask(_ task: Task) {
        fetchTasks()
    }
}

extension TasksListVC: DatePickerProtocol {
    func didSelectedDate(date: Date) {
        let df = Utils.dateFormatted(dateFormatter: appDelegate.dateFormatter, date)
        dateSelected = df.date
        setDateButton(dateStr: df.dateStr)
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
    
    func tableView(_ tableView: NSTableView, rowActionsForRow row: Int, edge: NSTableView.RowActionEdge) -> [NSTableViewRowAction] {
        if edge == .trailing {
            let deleteAction = NSTableViewRowAction(style: .destructive, title: "Eliminar", handler: { (rowAction,
                row) in
                let alert = NSAlert()
                alert.alertStyle = .warning
                alert.informativeText = "¿Estás seguro de eliminar esta tarea?\n El cambio no puede deshacerse."
                alert.addButton(withTitle: "Eliminar")
                alert.addButton(withTitle: "Cancelar")
                alert.messageText = "Eliminar tarea"
                alert.beginSheetModal(for: self.view.window!) { (response) in
                    if response == .alertFirstButtonReturn {
                        tableView.removeRows(at: IndexSet(integer: row), withAnimation: .effectFade)
                        self.deleteTask(row)
                    }
                }
            })
            deleteAction.backgroundColor = NSColor.red
            return [deleteAction]
        }
        
        return []
    }
    
}
