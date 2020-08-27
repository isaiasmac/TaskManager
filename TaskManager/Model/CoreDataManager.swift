//
//  CoreDataManager.swift
//  TaskManager
//
//  Created by Isaias on 23-08-20.
//  Copyright © 2020 IsaiasMac. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    
    private let container : NSPersistentContainer!
    
    init() {
        container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { (desc, error) in
            if let error = error {
                debugPrint("Error loading store \(desc) — \(error)")
                return
            }
            debugPrint("Database ready!")
        }
    }
        
}
