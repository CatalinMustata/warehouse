//
//  MenuVM.swift
//  Warehouse
//
//  Created by Catalin Mustata on 03/01/2019.
//  Copyright © 2019 BearSoft. All rights reserved.
//

import Cocoa

enum TabViewType: Int {
    case parts = 1
    case organization = 2
    case bom = 3
}

typealias CellConfiguration = (NSUserInterfaceItemIdentifier, String?)

final class MenuVM {
    private static let partCategories = [PartCategory("PASSIVE", withChildren: [ResistorModel.self, CapacitorModel.self])]

    private static let orgCategories = ["Boxes", "Manufacturers"]

    var dataViewType: TabViewType = .parts

    var itemCount: Int {
        switch dataViewType {
        case .parts:
            return MenuVM.partCategories.count
        case .organization:
            return MenuVM.orgCategories.count
        default:
            return 0
        }
    }

    func isGroup(_ item: Any) -> Bool {
        switch dataViewType {
        case .parts:
            return item is PartCategory
        default:
            return false
        }
    }

    func shouldSelect(_ item: Any) -> Bool {
        switch dataViewType {
        case .parts:
            return !(item is PartCategory)
        default:
            return true
        }
    }

    func cellConfiguration(for item: Any) -> CellConfiguration {
        switch dataViewType {
        case .parts:
            return partCellConfiguration(for: item)
        case .organization:
            return orgCellConfiguration(for: item)
        default:
            print("Invalid request of a cell configuration for: \(String(describing: item))")
            return (SideBarCellIdentifiers.selectableEntryCell, nil)
        }
    }

    func childCount(of item: Any?) -> Int {
        switch dataViewType {
        case .parts:
            return partChildCount(for: item)
        case .organization:
            return item == nil ? MenuVM.orgCategories.count : 0
        case .bom:
            fallthrough
        default:
            return 0
        }
    }

    func child(of item: Any?, at index: Int) -> Any {
        switch dataViewType {
        case .parts:
            return partChild(of: item, at: index)
        case .organization:
            return MenuVM.orgCategories[index]
        default:
            return 0
        }
    }

    // MARK: Private

    private func partChildCount(for item: Any?) -> Int {
        if item == nil {
            return MenuVM.partCategories.count
        } else {
            if let category = item as? PartCategory, let count = category.children?.count {
                return count
            } else {
                return 0
            }
        }
    }

    private func partChild(of item: Any?, at index: Int) -> Any {
        if item == nil {
            return MenuVM.partCategories[index]
        } else {
            guard let category = item as? PartCategory, let children = category.children else {
                print("\(String(describing:item)) is not a Part Category (only item with children)")
                abort()
            }

            return children[index]
        }
    }

    private func partCellConfiguration(for item: Any) -> CellConfiguration {
        var identifier: NSUserInterfaceItemIdentifier!
        var stringValue: String?

        if let category = item as? PartCategory {
            identifier = SideBarCellIdentifiers.categoryCell
            stringValue = category.name
        } else if let type = item as? PartModel.Type {
            identifier = SideBarCellIdentifiers.selectableEntryCell
            stringValue = type.groupName
        } else {
            print("\(String(describing:item)) is not supported")
        }

        return (identifier, stringValue)
    }

    private func orgCellConfiguration(for item: Any) -> CellConfiguration {
        var identifier: NSUserInterfaceItemIdentifier!
        var stringValue: String?

        if let org = item as? String {
            identifier = SideBarCellIdentifiers.selectableEntryCell
            stringValue = org
        } else {
            print("\(String(describing:item)) is not supported")
        }

        return (identifier, stringValue)
    }
}
