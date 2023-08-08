//
//  CSMenu.swift
//  CSMenu
//
//  Created by Cameron Goddard on 7/4/23.
//

import Cocoa

class CSMenu: NSObject {
    
    public private(set) var items: [CSMenuItem]
    public var panel: CSMenuPanel?
    
    private var parentWindow: NSWindow?
    
    init(items: [CSMenuItem]) {
        self.items = items
    }
    
    public func addItem(_ newItem: CSMenuItem) {
        self.items.append(newItem)
    }
    
    public override init() {
        self.items = []
    }
    
    public func popUp(at location: NSPoint, in view: NSView) {
        self.panel = CSMenuPanel(at: location, items: self.items)
        view.window?.addChildWindow(self.panel!, ordered: .above)
        self.parentWindow = view.window!
    }
    
    public func dismiss() {
        self.parentWindow?.removeChildWindow(panel!)
        self.panel!.close()
    }
}
