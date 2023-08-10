//
//  CSMenu.swift
//  CSMenu
//
//  Created by Cameron Goddard on 7/4/23.
//

import Cocoa

protocol CSMenuDelegate: AnyObject {
    func menuDidClose()
}

class CSMenu {
    
    public private(set) var items: [CSMenuItem]
    public var panel: CSMenuPanel?
    
    private var parentWindow: NSWindow?
    
    private var monitor: Any?
    
    weak var delegate: CSMenuDelegate?
    
    init(items: [CSMenuItem]) {
        self.items = items
        for item in self.items {
            item.csMenu = self
        }
    }
    
    deinit {
        removeMonitor()
    }
    
    public func addItem(_ newItem: CSMenuItem) {
        newItem.csMenu = self
        self.items.append(newItem)
    }
    
    public init() {
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
        delegate?.menuDidClose()
    }
    
    func addMonitor(ignoring views: [NSView]? = nil) {
        monitor = NSEvent.addLocalMonitorForEvents(matching: .leftMouseDown) { (event) -> NSEvent? in
            if !self.panel!.frame.contains(event.locationInWindow) {
                for ignoreView in views ?? [NSView]() {
                    let frameInWindow: NSRect = ignoreView.convert(ignoreView.bounds, to: nil)
                    if frameInWindow.contains(event.locationInWindow) {
                        return event
                    }
                }
                self.dismiss()
            }
            return event
        }
    }
    
    private func removeMonitor() {
        if monitor != nil {
            NSEvent.removeMonitor(monitor!)
            monitor = nil
        }
    }
}
