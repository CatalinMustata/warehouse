//
//  PartModel.swift
//  Warehouse
//
//  Created by Catalin Mustata on 28/12/2018.
//  Copyright © 2018 BearSoft. All rights reserved.
//

import CoreData

public class PartModel: NSManagedObject {
    class var groupName: String {
        return "Generic Parts"
    }

    class var entityName: String {
        return "Part"
    }

    var displayValueString: String {
        return String(value)
    }
}
