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
    public var panel: NSPanel?
    
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
        self.panel = CSMenuPanel()
        //self.panel = NSPanel(contentRect: .zero, styleMask: .borderless, backing: .buffered, defer: false)
        
        let contentVC = CSViewController(menuItems: self.items)
        self.panel!.contentViewController = contentVC
        
        view.window?.addChildWindow(self.panel!, ordered: .above)
        self.parentWindow = view.window!
        self.panel?.setFrameOrigin(.init(x: location.x, y: location.y + (21 * SCALE)))
    }
    
    public func dismiss() {
        self.parentWindow?.removeChildWindow(panel!)
        self.panel!.close()
        delegate?.menuDidClose()
    }
    
    func addMonitor(ignoring view: NSView? = nil) {
        monitor = NSEvent.addLocalMonitorForEvents(matching: .leftMouseDown) { (event) -> NSEvent? in
            if !(event.window is CSMenuPanel) {
                if let ignoreView = view {
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
    
    func removeMonitor() {
        if monitor != nil {
            NSEvent.removeMonitor(monitor!)
            monitor = nil
        }
    }
}
