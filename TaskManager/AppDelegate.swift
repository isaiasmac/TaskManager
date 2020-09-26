//
//  AppDelegate.swift
//  TaskManager
//
//  Created by Isaias on 21-08-20.
//  Copyright © 2020 IsaiasMac. All rights reserved.
//

import Cocoa
import Sparkle

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
    }

    
    let dateFormatter = DateFormatter()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "taskmanager_model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        })
        return container
    }()

    
    @IBAction func showPreferences(_ sender: NSMenuItem) {
        print("Mostrar ventana preferencias.")
    }
    
    @IBAction func checkForUpdates(_ sender: SUUpdater) {
        print("\(#function) sender: \(sender)")
    }
    
}

