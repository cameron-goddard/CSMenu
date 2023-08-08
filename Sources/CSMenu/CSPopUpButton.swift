//
//  CSPopUpButton.swift
//  CSMenu Test
//
//  Created by Cameron Goddard on 7/5/23.
//

import Cocoa

public class CSPopUpButton: NSButton {
    // TODO: change
    var popUpMenu: CSMenu?
    
    // TODO: make private
    var menuItems: [CSMenuItem] = []
    private var isShown = false
    
    public var lastItem: CSMenuItem?
    
    private let base = NSImage(named: "cs_button")!
    private let basePressed = NSImage(named: "cs_button_pressed")!
    
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    internal func setup() {
        self.setButtonType(.pushOnPushOff)
        base.size = .init(width: 31 * SCALE, height: 24 * SCALE)
        basePressed.size = .init(width: 31 * SCALE, height: 24 * SCALE)
        self.image = base
    }
    
    public func addItem(withTitle title: String) {
        let item = CSMenuItem(title: title, target: nil, action: nil)
        self.menuItems.append(item)
        self.lastItem = item
    }

    public override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    public override func mouseDown(with event: NSEvent) {
        // TODO: Add monitors if no mouseDown override
        if self.state == .on {
            self.image = self.base
            self.state = .off
        } else {
            self.image = self.basePressed
            self.state = .on
        }
        
        let buttonFrame = self.convert(self.bounds, to: nil)
        let windowFrame = self.superview?.window!.convertToScreen(buttonFrame)
        let screenOrigin = windowFrame!.origin
        
        if let popUp = popUpMenu {
            if popUp.panel!.parent == superview!.window {
                popUp.dismiss()
            } else {
                popUp.popUp(at: screenOrigin, in: superview!)
            }
        } else {
            print("in this branch")
            popUpMenu = CSMenu(items: self.menuItems)
            popUpMenu?.popUp(at: screenOrigin, in: superview!)
        }
    }
}
