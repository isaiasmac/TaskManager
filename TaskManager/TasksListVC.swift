//
//  TasksListVC.swift
//  TaskManager
//
//  Created by Isaias on 21-08-20.
//  Copyright © 2020 IsaiasMac. All rights reserved.
//

import Cocoa

class TasksDateListVC: NSViewController {
    
    @IBOutlet weak var tableView: NSTableView!
    
    var tasks = ["Tarea 1.", "Tarea 2", "Tarea 3", "Tarea 4", "Tarea 5"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
}

extension TasksDateListVC: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        tasks.count
    }
}

extension TasksDateListVC: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let view = tableView.makeView(withIdentifier: tableColumn!.identifier, owner: self) as? NSTableCellView
        
        view?.textField?.stringValue = tasks[row]
        return view
    }
}
