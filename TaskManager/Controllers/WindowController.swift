//
//  WindowController.swift
//  TaskManager
//
//  Created by Isaias on 22-08-20.
//  Copyright © 2020 IsaiasMac. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
        
        self.window?.titleVisibility = .hidden
        self.window?.backgroundColor = NSColor(calibratedRed: 1.00, green: 0.80, blue: 0.00, alpha: 1.00)
    }
    
}
