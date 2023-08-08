//
//  CSMenuButton.swift
//  CSMenu Test
//
//  Created by Cameron Goddard on 8/7/23.
//

import Cocoa

public class CSMenuItem: NSButton {
    
    var isSeparatorItem: Bool = false
    
    private var trackingArea : NSTrackingArea!
    private let overlayLayer = CALayer()

    public override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    public override init(frame: NSRect) {
        super.init(frame: frame)
        setup()
    }
    
    internal func setup() {
        self.bezelStyle = .regularSquare
        self.isBordered = false
        (self.cell as! NSButtonCell).imageDimsWhenDisabled = false
        self.wantsLayer = true
        
        let opts: NSTrackingArea.Options = ([.mouseEnteredAndExited, .activeAlways])
        trackingArea = NSTrackingArea(rect: bounds, options: opts, owner: self, userInfo: nil)
        self.addTrackingArea(trackingArea)
    }
    
    public class func separator() -> CSMenuItem {
        let separatorItem = CSMenuItem()
        separatorItem.isSeparatorItem = true
        separatorItem.isEnabled = false
        return separatorItem
    }
    
    override func updateTrackingAreas() {
        super.updateTrackingAreas()
        
        trackingAreas.forEach { trackingArea in
            removeTrackingArea(trackingArea)
        }
        addTrackingRect(bounds, owner: self, userData: nil, assumeInside: false)
    }
    
    override func mouseEntered(with event: NSEvent) {
        super.mouseEntered(with: event)
        if (self.isEnabled) {
            // TODO: Tint the right color
            let overlayColor = NSColor(red: 0.5, green: 1.0, blue: 1.0, alpha: 0.5)
            overlayLayer.backgroundColor = overlayColor.cgColor
            overlayLayer.frame = self.bounds
            self.layer?.addSublayer(overlayLayer)
        }
    }
        
    override func mouseExited(with event: NSEvent) {
        super.mouseExited(with: event)
        if (self.isEnabled) {
            overlayLayer.removeFromSuperlayer()
        }
    }
}
