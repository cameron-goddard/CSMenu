//
//  CSPopUpButton.swift
//  CSMenu
//
//  Created by Cameron Goddard on 7/5/23.
//

import Cocoa

public class CSPopUpButton: NSButton, CSMenuDelegate {
    // TODO: change
    var popUpMenu: CSMenu?
    
    // TODO: make private
    public var menuItems: [CSMenuItem] = []
    private var isShown = false
    
    override public var state: NSControl.StateValue {
        didSet {
            if state == .on {
                self.image = self.texturePressed
            } else {
                self.image = self.texture
            }
        }
    }
    
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
//        (self.cell as! NSButtonCell).highlightsBy = .contentsCellMask
//        (self.cell as! NSButtonCell).showsStateBy = .pushInCellMask
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
        if self.state == .on {
            self.state = .off
        } else {
            self.state = .on
        }
        
        //super.mouseDown(with: event)
        
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
            //let slider = CSSliderPanel(at: screenOrigin)
            //superview!.window?.addChildWindow(slider, ordered: .above)
            popUpMenu = CSMenu(items: self.menuItems)
            popUpMenu?.popUp(at: screenOrigin, in: superview!)
            popUpMenu?.addMonitor(ignoring: [self])
            popUpMenu?.delegate = self
        }
    }
    
    func menuDidClose() {
        self.state = .off
    }
    
    private static func addIcon(base: NSImage, icon: NSImage, x: CGFloat, y: CGFloat) -> NSImage {
        let image = NSImage(size: base.size)
        image.lockFocus()
        
        base.draw(at: .zero, from: NSRect(origin: .zero, size: base.size), operation: .copy, fraction: 1.0)
        icon.draw(at: NSPoint(x: x, y: y), from: NSRect(origin: .zero, size: icon.size), operation: .sourceOver, fraction: 1.0)

        image.unlockFocus()
        return image
    }
}
