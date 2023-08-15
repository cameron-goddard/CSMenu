//
//  CSMenuPanel.swift
//  CSMenu
//
//  Created by Cameron Goddard on 7/4/23.
//

import Cocoa

let SCALE = 2.0

class CSMenuPanel: NSPanel {
    
    init() {
        super.init(contentRect: .zero, styleMask: .borderless, backing: .buffered, defer: false)
        self.backgroundColor = .black
        self.level = .popUpMenu
    }
    
}
