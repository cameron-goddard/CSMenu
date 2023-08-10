//
//  CSMenuPanel.swift
//  CSMenu
//
//  Created by Cameron Goddard on 7/4/23.
//

import Cocoa

let SCALE = 1.5

class CSMenuPanel: NSPanel {
    private var stackView: NSStackView?
    
    init(at location: NSPoint, items: [CSMenuItem]) {
        var height = 2.0 * SCALE
        for item in items {
            if item.isSeparatorItem {
                height += 6 * SCALE
            } else {
                height += 13 * SCALE
            }
        }
        // TODO: Change width based on content
        let frame = NSMakeRect(location.x, location.y + (24 - 3) * SCALE, 91 * SCALE, height)
        super.init(contentRect: frame, styleMask: .borderless, backing: .buffered, defer: false)
        
        self.isReleasedWhenClosed = false
        self.backgroundColor = .black
        self.level = .popUpMenu
        //self.hasShadow = true
        
        let stackView = NSStackView(frame: frame)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        var i = 0
        for menuItem in items {
            if items.count == 1 {
                menuItem.image = composeImage(left: "single_left", middle: "single_middle", right: "single_right")
            }
            else if i == 0 {
                menuItem.image = composeImage(left: "top_left", middle: "top_middle", right: "top_right")
            }
            else if menuItem.isSeparatorItem {
                menuItem.image = composeImage(left: "separator_left", middle: "separator_middle", right: "separator_right", sep: true)
            }
            else if i == items.count - 1 {
                menuItem.image = composeImage(left: "bottom_left", middle: "bottom_middle", right: "bottom_right")
            }
            else {
                menuItem.image = composeImage(left: "top_left", middle: "middle_middle", right: "middle_right")
            }
            if menuItem.state == .on {
                menuItem.image = CSMenuPanel.addSelected(base: menuItem.image!)
            }
            let atts: [NSAttributedString.Key: Any] = [
                //.font: NSFont(name: "FindersKeepers", size: 24)!,
                .foregroundColor: NSColor.black
            ]
            let attTitle = NSMutableAttributedString(string: menuItem.title, attributes: atts)
            menuItem.attributedTitle = attTitle
            stackView.addArrangedSubview(menuItem)
            i += 1
        }
        stackView.spacing = 0
        stackView.orientation = .vertical
        stackView.edgeInsets = .init(top: 0, left: 0, bottom: 0, right: 0)
        stackView.frame = self.frame
        self.contentView!.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: self.contentView!.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: self.contentView!.centerYAnchor)
        ])
    }
    
    private func composeImage(left: String, middle: String, right: String, sep: Bool = false) -> NSImage {
        let height: Double
        if sep {
            height = 6
        } else {
            height = 13
        }
        
        let baseImage = NSImage(size: .init(width: 89 * SCALE, height: height * SCALE))
        baseImage.lockFocus()
        
        let middle = Bundle.module.image(forResource: middle)!
        middle.size = .init(width: 89 * SCALE, height: height * SCALE)
        middle.draw(at: .zero, from: NSRect(origin: .zero, size: middle.size), operation: .copy, fraction: 1.0)

        let right = Bundle.module.image(forResource: right)!
        right.size = .init(width: SCALE, height: height * SCALE)
        right.draw(at: NSPoint(x: 88 * SCALE, y: 0), from: NSRect(origin: .zero, size: right.size), operation: .sourceOver, fraction: 1.0)
        
        let left = Bundle.module.image(forResource: left)!
        left.size = .init(width: SCALE, height: height * SCALE)
        left.draw(at: .zero, from: NSRect(origin: .zero, size: left.size), operation: .sourceOver, fraction: 1.0)
        
        baseImage.unlockFocus()
        return baseImage
    }
    
    private static func addSelected(base: NSImage) -> NSImage {
        let image = NSImage(size: base.size)
        image.lockFocus()
        let selected = Bundle.module.image(forResource: "selected")!
        selected.size = .init(width: selected.size.width * SCALE, height: selected.size.height * SCALE)
        
        base.draw(at: .zero, from: NSRect(origin: .zero, size: base.size), operation: .copy, fraction: 1.0)
        selected.draw(at: NSPoint(x: 2 * SCALE, y: 4 * SCALE), from: NSRect(origin: .zero, size: selected.size), operation: .sourceOver, fraction: 1.0)

        image.unlockFocus()
        return image
    }
    
}
