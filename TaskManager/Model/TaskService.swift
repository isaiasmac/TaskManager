//
//  TaskService.swift
//  TaskManager
//
//  Created by Isaias on 26-08-20.
//  Copyright © 2020 IsaiasMac. All rights reserved.
//

import Foundation
import CoreData


class TaskService {
    
    var context: NSManagedObjectContext
    
    init(_ context: NSManagedObjectContext) {
        self.context = context
    }
    
    func fetch(date: Date, completionBlock: ((_ tasks: [Task]) -> ())) {
        let toPredicate = NSPredicate(format: "created == %@",
                                      argumentArray: [Utils.dateSimpleFormat(date: date)])
        
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        fetchRequest.predicate = toPredicate
        do {
            let result = try context.fetch(fetchRequest)
            completionBlock(result)
        }
        catch {
            debugPrint("Fetch Error: \(error.localizedDescription)")
        }
    }
    
    
    func save(_ params: [String: Any] = [:], completionBlock: ((_ task: Task) -> ())) {
        let dateSelected = params["date"] as! Date
        
        let task = Task(context: context)
        task.title = params["title"] as? String
        task.comments = params["comments"] as? String
        task.label = params["label"] as? String
        task.created = Utils.dateSimpleFormat(date: dateSelected)
        task.timestamp = dateSelected.timeIntervalSince1970
        task.dayadded = Utils.dayFromDate(date: dateSelected)
        do {
            try context.save()
            debugPrint("Saved OK!")
            completionBlock(task)
        }
        catch {
            debugPrint("SAVE Error: \(error.localizedDescription)")
        }
    }
    
    func update(task: Task, completionBlock: (() -> ())? = nil) {
        do {
            try context.save()
            debugPrint("Saved OK! ## task: \(task.status)")
            completionBlock?()
        }
        catch {
            debugPrint("SAVE Error: \(error.localizedDescription)")
        }
    }
    
    func delete(task: Task, completionBlock: (() -> ())? = nil) {
        context.delete(task)
        do {
            try context.save()
            debugPrint("DELETE OK! ## task: \(String(describing: task.title))")
            completionBlock?()
        }
        catch {
            debugPrint("SAVE Error: \(error.localizedDescription)")
        }
    }
}
