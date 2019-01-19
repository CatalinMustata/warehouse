//
//  ResistorModel.swift
//  Warehouse
//
//  Created by Catalin Mustata on 28/12/2018.
//  Copyright © 2018 BearSoft. All rights reserved.
//

import CoreData

@objc(ResistorModel)
public class ResistorModel: PartModel {
    override class var groupName: String {
        return "Resistors"
    }

    override class var entityName: String {
        return "Resistor"
    }

    override var displayValueString: String {
        var separator: String!
        var factor: Int64!

        switch value {
        case let value where value > 1_000:
            factor = 1000
            separator = "K"
        case let value where value > 1_000_000:
            factor = 1000000
            separator = "M"
        case let value where value > 1_000_000_000:
            factor = 1_000_000_000
        default:
            factor = 1
            separator = ""
        }

        let valueMajor = value / factor
        let valueMinor = value % factor != 0 ? "\(value % factor)" : ""

        return "\(valueMajor)\(separator!)\(valueMinor)"
    }

    override class var displayableFields: [DisplayableField]? {
        return [.manufacturer, .value, .stock, .box]
    }

    override func textFor(_ field: DisplayableField) -> String? {
        switch field {
        case .value:
            return displayValueString
        case .manufacturer:
            return manufacturer?.name
        default:
            return nil
        }
    }
}
