//
//  CSSliderCell.swift
//  
//
//  Created by Cameron Goddard on 8/9/23.
//

import Cocoa

class CSSliderCell: NSSliderCell {
    
    private let bar: NSImage
    
    required init(coder aDecoder: NSCoder) {
        self.bar = NSImage(named: "cs_slider_middle")!
        super.init(coder: aDecoder)
    }
    
    override init() {
        self.bar = NSImage(named: "cs_slider_middle")!
        super.init()
    }

    override func drawBar(inside aRect: NSRect, flipped: Bool) {
        var rect = aRect
        rect.size = NSSize(width: rect.width, height: 3)
        self.bar.draw(in: rect)
        super.drawBar(inside: rect, flipped: flipped)
    }

}
