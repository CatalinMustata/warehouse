//
//  StoryboardIdentifiers.swift
//  Warehouse
//
//  Created by Catalin Mustata on 03/01/2019.
//  Copyright © 2019 BearSoft. All rights reserved.
//
import Cocoa

struct TabMenuButtons {
    static let partsButton = NSUserInterfaceItemIdentifier("partsTabButton")
    static let organizationButton = NSUserInterfaceItemIdentifier("organizationTabButton")
    static let bomButton = NSUserInterfaceItemIdentifier("bomTabButton")
}

struct SideBarCellIdentifiers {
    static let categoryCell = NSUserInterfaceItemIdentifier(rawValue: "PartCategoryCell")
    static let selectableEntryCell = NSUserInterfaceItemIdentifier(rawValue: "PartTypeCell")
}
