//
//  CSPopUpButton.swift
//  CSMenu
//
//  Created by Cameron Goddard on 7/5/23.
//

import Cocoa

public class CSPopUpButton: NSButton {
    // TODO: change
    var popUpMenu: CSMenu?
    
    // TODO: make private
    public var menuItems: [CSMenuItem] = []
    private var isShown = false
    
    private var icon: NSImage?
    private var texture: NSImage?
    private var texturePressed: NSImage?
    
    public var lastItem: CSMenuItem?
    
    private let base = Bundle.module.image(forResource: "cs_button")!
    private let basePressed = Bundle.module.image(forResource: "cs_button_pressed")!
    
    public init(icon: NSImage) {
        self.icon = icon
        self.icon!.size = .init(width: icon.size.width * SCALE, height: icon.size.height * SCALE)
        super.init(frame: NSRect(x: 0, y: 0, width: 31 * SCALE, height: 24 * SCALE))
        setup()
    }
    
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    internal func setup() {
        self.isBordered = false
        self.setButtonType(.pushOnPushOff)
        base.size = .init(width: 31 * SCALE, height: 24 * SCALE)
        basePressed.size = .init(width: 31 * SCALE, height: 24 * SCALE)
        
        if let icon = self.icon {
            self.texture = CSPopUpButton.addIcon(base: self.base, icon: icon, x: 3 * SCALE, y: 4 * SCALE)
            self.texturePressed = CSPopUpButton.addIcon(base: self.basePressed, icon: icon, x: 4 * SCALE, y: 3 * SCALE)
        } else {
            self.texture = self.base
            self.texturePressed = self.basePressed
        }
        
        self.image = self.texture
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
            self.image = self.texture
            self.state = .off
        } else {
            self.image = self.texturePressed
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
    
    private static func addIcon(base: NSImage, icon: NSImage, x: CGFloat, y: CGFloat) -> NSImage {
        let image = NSImage(size: base.size)
        image.lockFocus()
        
        base.draw(at: NSPoint.zero, from: NSRect(origin: NSPoint.zero, size: base.size), operation: .copy, fraction: 1.0)
        icon.draw(at: NSPoint(x: x, y: y), from: NSRect(origin: NSPoint.zero, size: icon.size), operation: .sourceOver, fraction: 1.0)

        image.unlockFocus()
        return image
    }
}
