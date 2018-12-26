//
//  ViewController.swift
//  Warehouse
//
//  Created by Catalin Mustata on 26/12/2018.
//  Copyright © 2018 BearSoft. All rights reserved.
//

import Cocoa

class ContainerVC: NSSplitViewController {

    var menuVC : NSViewController!
    var contentVC : NSViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        menuVC = splitViewItems[0].viewController
        contentVC = splitViewItems[1].viewController

        menuVC.view.setBackgroundColor(.darkGray)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    override func splitView(_ splitView: NSSplitView, constrainSplitPosition proposedPosition: CGFloat, ofSubviewAt dividerIndex: Int) -> CGFloat {
        return max(proposedPosition, 200.0)
    }
}

extension NSView {
    func setBackgroundColor(_ color: NSColor) {
        wantsLayer = true
        layer?.backgroundColor = color.cgColor
    }
}

