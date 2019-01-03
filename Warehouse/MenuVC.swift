//
//  MenuVC.swift
//  Warehouse
//
//  Created by Catalin Mustata on 26/12/2018.
//  Copyright © 2018 BearSoft. All rights reserved.
//

import Cocoa

protocol MenuViewControllerDelegate: class {
    func partTypeDidChangeTo(_ partType: PartModel.Type) -> Void
}

class MenuVC: NSViewController, NSWindowDelegate {
    @IBOutlet weak var outlineView: NSOutlineView!
    @IBOutlet weak var contentScrollView: NSScrollView!

    weak var menuDelegate: MenuViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        outlineView.delegate = self
        outlineView.dataSource = self

        outlineView.expandItem(nil, expandChildren: true)

        contentScrollView.automaticallyAdjustsContentInsets = false
        contentScrollView.contentInsets = NSEdgeInsets(top: 30, left: 0, bottom: 0, right: 0)
    }
}

extension MenuVC: NSOutlineViewDelegate, NSOutlineViewDataSource {

    static let categories = [PartCategory("PASSIVE", withChildren: [ResistorModel.self, CapacitorModel.self])]

    // MARK: DataSource

    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        if let category = item as? PartCategory {
            return category.children != nil
        } else {
            return false
        }
    }

    func outlineView(_ outlineView: NSOutlineView, objectValueFor tableColumn: NSTableColumn?, byItem item: Any?) -> Any? {
        if let category = item as? PartCategory {
            return category.name
        } else if let type = item as? PartModel.Type {
            return type.groupName
        } else {
            return nil
        }
    }

    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if item == nil {
            return MenuVC.categories[index]
        } else {
            guard let category = item as? PartCategory, let children = category.children else {
                print("\(String(describing:item)) is not a Part Category (only item with children)")
                abort()
            }

            return children[index]
        }
    }

    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if item == nil {
            return MenuVC.categories.count
        } else {
            if let category = item as? PartCategory, let count = category.children?.count {
                return count
            } else {
                return 0
            }
        }
    }

    // MARK: Delegate

    func outlineViewSelectionDidChange(_ notification: Notification) {
        guard let menu = notification.object as? NSOutlineView else {
            print("Notification did not came from outline view.")
            return
        }

        if let partType = menu.item(atRow: menu.selectedRow) as? PartModel.Type {
            menuDelegate?.partTypeDidChangeTo(partType)
        } else {
            print("error")
        }
    }

    func outlineView(_ outlineView: NSOutlineView, isGroupItem item: Any) -> Bool {
        return item is PartCategory
    }

    func outlineView(_ outlineView: NSOutlineView, shouldShowOutlineCellForItem item: Any) -> Bool {
        return false
    }

    func outlineView(_ outlineView: NSOutlineView, shouldSelectItem item: Any) -> Bool {
        return !(item is PartCategory)
    }

    func outlineView(_ outlineView: NSOutlineView, heightOfRowByItem item: Any) -> CGFloat {
        return 24
    }

    func outlineView(_ outlineView: NSOutlineView, rowViewForItem item: Any) -> NSTableRowView? {
        return OutlineSelectableCell()
    }

    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        var identifier: NSUserInterfaceItemIdentifier!
        var entryName: String?

        if let category = item as? PartCategory {
            identifier = NSUserInterfaceItemIdentifier(rawValue: "PartCategoryCell")
            entryName = category.name
        } else if let type = item as? PartModel.Type {
            identifier = NSUserInterfaceItemIdentifier(rawValue: "PartTypeCell")
            entryName = type.groupName
        } else {
            print("\(String(describing:item)) is not supported")
        }

        let view = outlineView.makeView(withIdentifier: identifier, owner: self) as? NSTableCellView
        if let title = entryName {
            view?.textField?.stringValue = title
        }

        return view
    }
}
