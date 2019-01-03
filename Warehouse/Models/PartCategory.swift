//
//  PartsHierarchy.swift
//  Warehouse
//
//  Created by Catalin Mustata on 27/12/2018.
//  Copyright © 2018 BearSoft. All rights reserved.
//

struct PartCategory {
    let name: String
    let children: [PartModel.Type]?

    init(_ name: String, withChildren children: [PartModel.Type]?){
        self.name = name
        self.children = children
    }
}
