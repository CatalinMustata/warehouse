//
//  PartModel.swift
//  Warehouse
//
//  Created by Catalin Mustata on 28/12/2018.
//  Copyright © 2018 BearSoft. All rights reserved.
//

import CoreData

enum DisplayableField {
    case name
    case model
    case value
    case stock
    case box
    case manufacturer
}

public class ListEntryModel: NSManagedObject {
    class var entityName: String {
        preconditionFailure("entityName must be override by subclass")
    }

    class var displayableFields: [DisplayableField]? {
        preconditionFailure("displayableFields must be overriden by subclass")
    }

    func textFor(_ field: DisplayableField) -> String? {
        preconditionFailure("textFor(:) must be overriden by subclass")
    }
}
