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
        "Resistors"
    }

    override class var entityName: String {
        "Resistor"
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
        return (super.displayableFields ?? []) + [.type, .rating]
    }

    override func textFor(_ field: DisplayableField) -> String? {
        switch field {
        case .value:
            return displayValueString
        case .manufacturer:
            return manufacturer?.name
        case .code:
            return code
        case .model:
            return descriptor
        case .stock:
            return "\(quantity)"
        case .box:
            return box?.name
        case .type:
            return "\(type)"
        case .rating:
            return ratingString
        }
    }

    override func set(_ value: Any, for field: DisplayableField) -> Bool {
        if !super.set(value, for: field) {
            switch field {
            case .rating:
                self.rating = NSDecimalNumber(string: value as? String)
            case .type:
                self.type = value as? Int16 ?? 0 //TODO: Add actual type
            default:
                return false
            }
        }

        return true
    }

    private var ratingString: String {
        guard let rating = rating, rating != 0 else {
            return "N/A"
        }

        if rating.doubleValue >= 1 {
            return "\(rating) W"
        } else {
            let one = NSDecimalNumber(integerLiteral: 1)
            let scale = one.dividing(by: rating, withBehavior: nil)

            return "1/\(scale) W"
        }
    }
}
