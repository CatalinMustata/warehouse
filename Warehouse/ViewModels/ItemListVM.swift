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
        TableCellIdentifiers.manufacturerCell:  .manufacturer,
        TableCellIdentifiers.valueCell:         .value,
        TableCellIdentifiers.boxCell:           .box,
        TableCellIdentifiers.modelCell:         .model,
        TableCellIdentifiers.typeCell:          .type,
        TableCellIdentifiers.codeCell:          .code,
        TableCellIdentifiers.stockCell:         .stock,
        TableCellIdentifiers.ratingCell:        .rating
    ]

    static let forField: Dictionary<DisplayableField, ColumnDescriptor> = [
        .manufacturer : (TableCellIdentifiers.manufacturerCell, "Manufacturer"),
        .value: (TableCellIdentifiers.valueCell, "Value"),
        .stock: (TableCellIdentifiers.stockCell, "Stock"),
        .box: (TableCellIdentifiers.boxCell, "Box"),
        .type: (TableCellIdentifiers.typeCell, "Type"),
        .code: (TableCellIdentifiers.codeCell, "Code"),
        .model: (TableCellIdentifiers.modelCell, "Model"),
        .rating: (TableCellIdentifiers.ratingCell, "Rating")
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
        } catch {
            print(error)
            items = []
        }
    }

    mutating func add(_ item: T) {
        items?.append(item)
    }
}

class ItemListVM<T: ListEntryModel> {
    private var entryList: PartList<T>

    var viewCount: Int {
        return entryList.items?.count ?? 0
    }

    private (set) var columnList = [ColumnDescriptor]()

    private var createNewEntry: (NSManagedObjectContext) -> T

    init(of type: T.Type) {
        entryList = PartList(of: type)

        createNewEntry = { context in
            return type.init(context: context)
        }

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

    func addNewEntry() -> Void {
        guard let application = NSApplication.shared.delegate as? AppDelegate else {
            return
        }

        let context = application.persistentContainer.viewContext
        let newEntry = createNewEntry(context)

        do {
            try context.save()
        } catch {
            print(error)
        }

        entryList.add(newEntry)
    }

    func updateItem(at index: Int, setting field: DisplayableField, to value: Any) -> Bool {
        guard let item = entryList.items?[index] else {
            print("invalid index")
            return false
        }

        guard item.set(value, for: field), let application = NSApplication.shared.delegate as? AppDelegate else {
            print("failed to set new value for field")
            return false
        }

        do {
            try application.persistentContainer.viewContext.save()
        } catch {
            print(error)
            return false
        }

        return true
    }
}

