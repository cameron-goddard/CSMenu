//
//  CSMenuButton.swift
//  CSMenu
//
//  Created by Cameron Goddard on 8/7/23.
//

import Cocoa

public class CSMenuItem: NSButton {
    
    var isSeparatorItem: Bool = false
    weak var csMenu: CSMenu?
    
    private var trackingArea : NSTrackingArea!
    private let overlayLayer = CALayer()

    public override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
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
        self.cell = CSMenuItemCell()
        self.bezelStyle = .regularSquare
        self.isBordered = false
        self.alignment = .left
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
        separatorItem.title = ""
        return separatorItem
    }
    
    public override func updateTrackingAreas() {
        super.updateTrackingAreas()
        
        trackingAreas.forEach { trackingArea in
            removeTrackingArea(trackingArea)
        }
        addTrackingRect(bounds, owner: self, userData: nil, assumeInside: false)
    }
    
    public override func mouseEntered(with event: NSEvent) {
        super.mouseEntered(with: event)
        if (self.isEnabled) {
            // TODO: Tint the right color
            let overlayColor = NSColor(red: 0, green: 0, blue: 1.0, alpha: 0.5)
            overlayLayer.backgroundColor = overlayColor.cgColor
            overlayLayer.frame = self.bounds
            self.layer?.addSublayer(overlayLayer)
            
            let atts: [NSAttributedString.Key: Any] = [
                //.font: NSFont(name: "FindersKeepers", size: 24)!,
                .foregroundColor: NSColor.white
            ]
            let attTitle = NSMutableAttributedString(string: self.title, attributes: atts)
            self.attributedTitle = attTitle
        }
    }
        
    public override func mouseExited(with event: NSEvent) {
        super.mouseExited(with: event)
        if (self.isEnabled) {
            overlayLayer.removeFromSuperlayer()
            let atts: [NSAttributedString.Key: Any] = [
                //.font: NSFont(name: "FindersKeepers", size: 24)!,
                .foregroundColor: NSColor.black
            ]
            let attTitle = NSMutableAttributedString(string: self.title, attributes: atts)
            self.attributedTitle = attTitle
        }
    }
    
    public override func mouseUp(with event: NSEvent) {
        // TODO: Fix this
        super.mouseUp(with: event)
        self.csMenu!.dismiss()
    }
    
}

class CSMenuItemCell: NSButtonCell {
    override func titleRect(forBounds rect: NSRect) -> NSRect {
        var title = super.titleRect(forBounds: rect)
        title.origin.x = title.origin.x + 20
        //title.origin.y = title.origin.y - 2
        return title
    }
}
