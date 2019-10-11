//
//  BoxModel.swift
//  Warehouse
//
//  Created by Catalin Mustata on 11/10/2019.
//  Copyright © 2019 BearSoft. All rights reserved.
//

import Foundation

@objc(BoxModel)
public class BoxModel: OrganizationModel {
    override class var entityName: String {
        "Box"
    }

    override class var displayableFields: [DisplayableField]? {
        return [.name]
    }

    override func textFor(_ field: DisplayableField) -> String? {
        if field == .name {
            return name
        } else {
            return nil
        }
    }

    override func set(_ value: Any, for field: DisplayableField) -> Bool {
        guard let name = value as? String else {
            print("Unexpected type: \(type(of: value)) instead of String")
            return false
        }

        self.name = name
        return true
    }
}
