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

struct TableCellIdentifiers {
    // default cell used for creating new views
    static let defaultTextCell = NSUserInterfaceItemIdentifier(rawValue: "DefaultTextCell")
    // cell identifiers used to distinguish between different displayable properties
    static let manufacturerCell = NSUserInterfaceItemIdentifier(rawValue: "ManufacturerCell")
    static let valueCell = NSUserInterfaceItemIdentifier(rawValue: "ValueCell")
    static let modelCell = NSUserInterfaceItemIdentifier(rawValue: "ModelCell")
    static let boxCell =  NSUserInterfaceItemIdentifier(rawValue: "BoxCell")
    static let stockCell =  NSUserInterfaceItemIdentifier(rawValue: "StockCell")
    static let typeCell =  NSUserInterfaceItemIdentifier(rawValue: "TypeCell")
    static let codeCell =  NSUserInterfaceItemIdentifier(rawValue: "CodeCell")
    static let ratingCell =  NSUserInterfaceItemIdentifier(rawValue: "RatingCell")
}
