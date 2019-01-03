//
//  ViewController.swift
//  Warehouse
//
//  Created by Catalin Mustata on 26/12/2018.
//  Copyright © 2018 BearSoft. All rights reserved.
//

import Cocoa

class ContainerVC: NSSplitViewController {

    var menuVC : MenuVC!
    var contentVC : PartListVC!

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let menuVC = splitViewItems[0].viewController as? MenuVC else {
            print("Left panel not initialized with a Menu VC")
            abort()
        }

        guard let contentVC = splitViewItems[1].viewController as? PartListVC else {
            print("Right panel not initialized with a Part List VC")
            abort()
        }

        menuVC.menuDelegate = contentVC
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}
