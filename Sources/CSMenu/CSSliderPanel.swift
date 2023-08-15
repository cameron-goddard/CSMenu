//
//  CSSliderPanel.swift
//  
//
//  Created by Cameron Goddard on 8/9/23.
//

import Cocoa

class CSSliderPanel: NSPanel {
    
    private var slider: NSSlider = NSSlider(frame: .init(x: 0, y: 0, width: 30, height: 60))
    
    init(at location: NSPoint) {
        let frame = NSMakeRect(location.x, location.y + (24 - 3) * SCALE, 19 * SCALE, 60 * SCALE)
        super.init(contentRect: frame, styleMask: .borderless, backing: .buffered, defer: false)
        
        self.isReleasedWhenClosed = false
        //self.backgroundColor = .black
        self.level = .popUpMenu
        self.slider.isVertical = true
        self.slider.cell = CSMenuItemCell()
        self.slider.cell?.target = self
        self.slider.cell?.action = #selector(self.seek(_:))
        
//        self.slider.minValue = 0
//        self.slider.minValue = 100
        
        //self.slider.translatesAutoresizingMaskIntoConstraints = false
        //self.slider.frame = self.frame
        self.contentView?.addSubview(self.slider)
        
//        NSLayoutConstraint.activate([
//            self.slider.centerXAnchor.constraint(equalTo: self.contentView!.centerXAnchor),
//            self.slider.centerYAnchor.constraint(equalTo: self.contentView!.centerYAnchor)
//        ])
    }
    
    @objc func seek(_ sender: NSObject) {
        //let val = seekSlider.cell?.floatValue
        //print("\(String(describing: val))")
    }
    
    

}
