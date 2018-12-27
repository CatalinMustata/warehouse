//
//  PartsHierarchy.swift
//  Warehouse
//
//  Created by Catalin Mustata on 27/12/2018.
//  Copyright © 2018 BearSoft. All rights reserved.
//

import Cocoa

struct PartCategory {
    let name: String
    let children: [PartType]?

    init(_ name: String, withChildren children: [PartType]?){
        self.name = name
        self.children = children
    }
}

struct PartType {
    let name: String

    init(_ name: String) {
        self.name = name
    }
}
