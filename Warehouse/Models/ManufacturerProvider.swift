//
//  ManufacturerProvider.swift
//  Warehouse
//
//  Created by Catalin Mustata on 11/10/2019.
//  Copyright © 2019 BearSoft. All rights reserved.
//

import AppKit

final class ManufacturerProvider: NSObject {
    private(set) static var sharedInstance = ManufacturerProvider()

    private var manufacturers: [ManufacturerModel]?

    override private init() {
        super.init()
        loadData()
    }

    func reloadData() {
        loadData()
    }

    func manufacturerNamed(_ name: String) -> ManufacturerModel? {
        guard let manufacturers = manufacturers else {
            return nil
        }

        for manufacturer in manufacturers {
            if manufacturer.name == name {
                return manufacturer
            }
        }

        return nil
    }

    private func loadData() {
        let request: NSFetchRequest<ManufacturerModel> = ManufacturerModel.fetchRequest()

        let context = (NSApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        do {
            manufacturers = try context.fetch(request)
        } catch {
            print("Failed to retrieve manufacturers: \(error)")
        }
    }
}

extension ManufacturerProvider: NSComboBoxDataSource {
    func numberOfItems(in comboBox: NSComboBox) -> Int {
        manufacturers?.count ?? 0
    }

    func comboBox(_ comboBox: NSComboBox, completedString string: String) -> String? {
        guard let manufacturers = manufacturers else {
            return nil
        }

        for manufacturer in manufacturers {
            guard let name = manufacturer.name else {
                continue
            }

            if name.contains(string) {
                return name
            }
        }

        return nil
    }

    func comboBox(_ comboBox: NSComboBox, objectValueForItemAt index: Int) -> Any? {
        guard let manufacturers = manufacturers, index >= manufacturers.startIndex && index < manufacturers.endIndex else {
            return nil
        }

        return manufacturers[index].name
    }
}
