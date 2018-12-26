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
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}
