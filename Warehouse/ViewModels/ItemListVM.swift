//
//  SmartViewModel.swift
//  Warehouse
//
//  Created by Catalin Mustata on 20/01/2019.
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

struct PartList<T: ListEntryModel> {

    private(set) var items: [T]?

    init(of partType: T.Type) {
        guard let application = NSApplication.shared.delegate as? AppDelegate else {
            items = []
            return
        }

        let fetchRequest = NSFetchRequest<T>(entityName: partType.entityName)

        let context = application.persistentContainer.viewContext

        do {
            try items = context.fetch(fetchRequest)
        } catch let error as NSError {
            print(error)
            items = []
        }
    }
}

class ItemListVM<T: ListEntryModel> {
    private var entryList: PartList<T>

    var viewCount: Int {
        return entryList.items?.count ?? 0
    }

    private (set) var columnList = [ColumnDescriptor]()

    init(of type: T.Type) {
        entryList = PartList(of: type)

        type.displayableFields?.forEach { (displayableField) in
            if let descriptor = ColumnMapping.forField[displayableField] {
                columnList.append(descriptor)
            }
        }
    }

    func textForEntry(at rowIndex: Int, columnIdentifier: NSUserInterfaceItemIdentifier) -> String {
        guard let items = entryList.items else {
            return "-"
        }

        let item = items[rowIndex]

        guard let field = ColumnMapping.forIdentifier[columnIdentifier] else {
            return "-"
        }

        return item.textFor(field) ?? "-"
    }

    func addEntry<T: ListEntryModel>(_ entry: T) -> Void {
        //nothing here yet
    }
}

