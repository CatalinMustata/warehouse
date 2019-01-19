//
//  ListViewModel.swift
//  Warehouse
//
//  Created by Catalin Mustata on 19/01/2019.
//  Copyright © 2019 BearSoft. All rights reserved.
//

import Cocoa

typealias ColumnDescriptor = (identifier: NSUserInterfaceItemIdentifier, title: String)

struct ColumnMapping {
    static let forIdentifier: Dictionary<NSUserInterfaceItemIdentifier, DisplayableField> = [
        TableCellIdentifiers.manufacturerCell: .manufacturer,
        TableCellIdentifiers.valueCell:        .value
    ]

    static let forField: Dictionary<DisplayableField, ColumnDescriptor> = [
        .manufacturer : (TableCellIdentifiers.manufacturerCell, "Manufacturer"),
        .value: (TableCellIdentifiers.valueCell, "Value")
    ]
}

protocol ListViewModel {
    associatedtype ItemModel where ItemModel: ListEntryModel

    var viewCount: Int { get };

    var columnList: [ColumnDescriptor] { get }

    init(of type: ItemModel.Type)

    func textForEntry(at rowIndex: Int, columnIdentifier: NSUserInterfaceItemIdentifier) -> String

    func addEntry(_ entry: ItemModel) -> Void
}
