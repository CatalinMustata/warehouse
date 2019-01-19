//
//  PartModel.swift
//  Warehouse
//
//  Created by Catalin Mustata on 19/01/2019.
//  Copyright © 2019 BearSoft. All rights reserved.
//

public class PartModel: ListEntryModel {
    override class var entityName: String {
        return "Part"
    }

    class var groupName: String {
        return "Generic Parts"
    }
    
    var displayValueString: String {
        return String(value)
    }
}
