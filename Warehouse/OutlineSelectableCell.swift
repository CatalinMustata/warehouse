//
//  OutlineSelectableCell.swift
//  Warehouse
//
//  Created by Catalin Mustata on 26/12/2018.
//  Copyright © 2018 BearSoft. All rights reserved.
//

import Cocoa

class OutlineSelectableCell: NSTableRowView {

    override var isEmphasized: Bool {
        get {
            return false
        }
        set {
            // yeah, I really don't want this to be emphasized. ever.
        }
    }
    
}
