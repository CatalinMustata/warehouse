//
//  PartListVC.swift
//  Warehouse
//
//  Created by Catalin Mustata on 26/12/2018.
//  Copyright © 2018 BearSoft. All rights reserved.
//

import Cocoa

class PartListVC: NSViewController {

    @IBOutlet weak var contentScrollView: NSScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        contentScrollView.automaticallyAdjustsContentInsets = false
        contentScrollView.contentInsets = NSEdgeInsets(top: 30, left: 0, bottom: 0, right: 0)
    }
    
}
