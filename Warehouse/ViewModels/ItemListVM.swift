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
    static let forIdentifier: [NSUserInterfaceItemIdentifier: DisplayableField] = [
        TableCellIdentifiers.manufacturerCell:  .manufacturer,
        TableCellIdentifiers.nameCell:          .name,
        TableCellIdentifiers.valueCell:         .value,
        TableCellIdentifiers.boxCell:           .box,
        TableCellIdentifiers.modelCell:         .model,
        TableCellIdentifiers.typeCell:          .type,
        TableCellIdentifiers.codeCell:          .code,
        TableCellIdentifiers.stockCell:         .stock,
        TableCellIdentifiers.ratingCell:        .rating
    ]

    static let representationFor: [NSUserInterfaceItemIdentifier: NSUserInterfaceItemIdentifier] = [
        TableCellIdentifiers.manufacturerCell:  TableCellIdentifiers.defaultComboCell,
        TableCellIdentifiers.valueCell:         TableCellIdentifiers.defaultTextCell,
        TableCellIdentifiers.boxCell:           TableCellIdentifiers.defaultComboCell,
        TableCellIdentifiers.modelCell:         TableCellIdentifiers.defaultTextCell,
        TableCellIdentifiers.typeCell:          TableCellIdentifiers.defaultTextCell,
        TableCellIdentifiers.codeCell:          TableCellIdentifiers.defaultTextCell,
        TableCellIdentifiers.stockCell:         TableCellIdentifiers.defaultTextCell,
        TableCellIdentifiers.ratingCell:        TableCellIdentifiers.defaultTextCell,
        TableCellIdentifiers.nameCell:          TableCellIdentifiers.defaultTextCell
    ]

    static let forField: [DisplayableField: ColumnDescriptor] = [
        .manufacturer: (TableCellIdentifiers.manufacturerCell, "Manufacturer"),
        .name: (TableCellIdentifiers.nameCell, "Name"),
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

    mutating func remove(at index: Int) {
        items?.remove(at: index)
    }
}

class ItemListVM<T: ListEntryModel> {
    private var entryList: PartList<T>

    var viewCount: Int {
        return entryList.items?.count ?? 0
    }

    private(set) var columnList = [ColumnDescriptor]()

    private var createNewEntry: (NSManagedObjectContext) -> T

    private var didCreateEntry: () -> Void

    init(of type: T.Type) {
        entryList = PartList(of: type)

        createNewEntry = { context in
            return type.init(context: context)
        }

        didCreateEntry = {
            if type is ManufacturerModel.Type {
                ManufacturerProvider.sharedInstance.reloadData()
            } else if type is BoxModel.Type {
                print("Should update boxes provider")
            }
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

        didCreateEntry()
    }

    func removeEntryAt(_ index: Int) {
        guard let application = NSApplication.shared.delegate as? AppDelegate, let item = entryList.items?[index] else {
            return
        }

        let context = application.persistentContainer.viewContext
        context.delete(item)

        do {
            try context.save()
            entryList.remove(at: index)
        } catch {
            print("Failed to remove item from DB: \(error)")
        }
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

