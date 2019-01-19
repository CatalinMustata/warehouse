//
//  PartListViewModel.swift
//  Warehouse
//
//  Created by Catalin Mustata on 19/01/2019.
//  Copyright © 2019 BearSoft. All rights reserved.
//
import Cocoa

struct PartList<T: PartModel> {

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


final class PartListViewModel<T: PartModel>: ListViewModel {
    var columnList = [ColumnDescriptor]()

    typealias ItemModel = T

    private var partList: PartList<T>?

    init(of type: T.Type) {
        partList = PartList(of: type)

        T.displayableFields?.forEach { (displayableField) in
            if let descriptor = ColumnMapping.forField[displayableField] {
                columnList.append(descriptor)
            }
        }
    }

    var viewCount: Int {
        return partList?.items?.count ?? 0
    }

    func textForEntry(at rowIndex: Int, columnIdentifier: NSUserInterfaceItemIdentifier) -> String {
        guard let items = partList?.items else {
            return "-"
        }

        let item = items[rowIndex]

        guard let field = ColumnMapping.forIdentifier[columnIdentifier] else {
            return "-"
        }

        return item.textFor(field) ?? "-"
    }

    func addEntry(_ entry: T) {
        // nothing here yet
    }
}
