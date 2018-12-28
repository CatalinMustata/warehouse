//
//  PartsHierarchy.swift
//  Warehouse
//
//  Created by Catalin Mustata on 27/12/2018.
//  Copyright © 2018 BearSoft. All rights reserved.
//

import Cocoa

struct PartCategory<T: PartModel> {
    let name: String
    let children: [T.Type]?

    init(_ name: String, withChildren children: [T.Type]?){
        self.name = name
        self.children = children
    }
}
