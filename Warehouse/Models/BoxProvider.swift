//
//  BoxProvider.swift
//  Warehouse
//
//  Created by Catalin Mustata on 27.10.2024.
//  Copyright © 2024 BearSoft. All rights reserved.
//

import AppKit

final class BoxProvider: NSObject {
    private(set) static var sharedInstance = BoxProvider()

    private var boxes: [BoxModel]?

    override private init() {
        super.init()
        loadData()
    }

    func reloadData() {
        loadData()
    }

    func boxNamed(_ name: String) -> BoxModel? {
        guard let boxes = boxes else {
            return nil
        }

        for box in boxes {
            if box.name == name {
                return box
            }
        }

        return nil
    }

    private func loadData() {
        let request: NSFetchRequest<BoxModel> = BoxModel.fetchRequest()

        let context = (NSApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        do {
            boxes = try context.fetch(request)
        } catch {
            print("Failed to retrieve boxes: \(error)")
        }
    }
}

extension BoxProvider: NSComboBoxDataSource {
    func numberOfItems(in comboBox: NSComboBox) -> Int {
        boxes?.count ?? 0
    }

    func comboBox(_ comboBox: NSComboBox, completedString string: String) -> String? {
        guard let boxes = boxes else {
            return nil
        }

        for box in boxes {
            guard let name = box.name else {
                continue
            }

            if name.contains(string) {
                return name
            }
        }

        return nil
    }

    func comboBox(_ comboBox: NSComboBox, objectValueForItemAt index: Int) -> Any? {
        guard let boxes = boxes, index >= boxes.startIndex && index < boxes.endIndex else {
            return nil
        }

        return boxes[index].name
    }
}
