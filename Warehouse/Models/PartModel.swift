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

    override func set(_ value: Any, for field: DisplayableField) -> Bool {
        switch field {
        case .box:
            guard let box = value as? Box else {
                print("Invalid value of type (\(type(of: value))) instead of Box")
                return false
            }

            self.box = box
        case .manufacturer:
            guard let manufacturer = value as? Manufacturer else {
                print("Invalid value of type (\(type(of: value))) instead of Manufacturer")
                return false
            }

            self.manufacturer = manufacturer
        case .stock:
            guard let stringValue = value as? String, let stock = Int16(stringValue) else {
                print("Invalid value of type (\(type(of: value))) instead of Int16 convertible")
                return false
            }

            self.quantity = stock
        case .value:
            guard let stringValue = value as? String, let partValue = Int64(stringValue) else {
                print("Invalid value of type (\(type(of: value))) instead of Int64 convertible")
                return false
            }

            self.value = partValue
        default:
            return false
        }

        return true
    }
}
