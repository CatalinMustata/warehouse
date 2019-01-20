//
//  MenuVC.swift
//  Warehouse
//
//  Created by Catalin Mustata on 26/12/2018.
//  Copyright © 2018 BearSoft. All rights reserved.
//

import Cocoa

protocol MenuViewControllerDelegate: class {
    func partTypeDidChangeTo(_ partType: ListEntryModel.Type) -> Void
}

class MenuVC: NSViewController, NSWindowDelegate {
    @IBOutlet weak var outlineView: NSOutlineView!
    @IBOutlet weak var contentScrollView: NSScrollView!
    @IBOutlet weak var tabMenuContainerView: NSView!

    weak var menuDelegate: MenuViewControllerDelegate?

    private var viewModel: MenuVM = MenuVM()

    override func viewDidLoad() {
        super.viewDidLoad()

        outlineView.delegate = self
        outlineView.dataSource = self

        outlineView.expandItem(nil, expandChildren: true)

        contentScrollView.automaticallyAdjustsContentInsets = false
        contentScrollView.contentInsets = NSEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)

        viewModel.dataViewType = .parts
        for view in tabMenuContainerView.subviews {
            if let button = view as? NSButton, button.identifier == TabMenuButtons.partsButton {
                button.state = .on
                break
            }
        }
    }

    @IBAction func tabBarButtonPushed(_ sender: NSButton) {
        switch sender.identifier {
        case TabMenuButtons.partsButton:
            viewModel.dataViewType = .parts
        case TabMenuButtons.organizationButton:
            viewModel.dataViewType = .organization
        case TabMenuButtons.bomButton:
            viewModel.dataViewType = .bom
        default:
            print("Unsupported button")
            return
        }

        outlineView.reloadData()
        outlineView.expandItem(nil, expandChildren: true)

        for view in tabMenuContainerView.subviews {
            if let button = view as? NSButton, button != sender {
                button.state = .off
            }
        }
    }
}

extension MenuVC: NSOutlineViewDelegate, NSOutlineViewDataSource {

    // MARK: DataSource

    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        return viewModel.isGroup(item) && viewModel.childCount(of: item) != 0
    }

    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        return viewModel.child(of: item, at: index)
    }

    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        return viewModel.childCount(of: item)
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
        return viewModel.isGroup(item)
    }

    func outlineView(_ outlineView: NSOutlineView, shouldShowOutlineCellForItem item: Any) -> Bool {
        return false
    }

    func outlineView(_ outlineView: NSOutlineView, shouldSelectItem item: Any) -> Bool {
        return viewModel.shouldSelect(item)
    }

    func outlineView(_ outlineView: NSOutlineView, heightOfRowByItem item: Any) -> CGFloat {
        return 24
    }

    func outlineView(_ outlineView: NSOutlineView, rowViewForItem item: Any) -> NSTableRowView? {
        return OutlineSelectableCell()
    }

    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        let (identifier, stringValue) = viewModel.cellConfiguration(for: item)

        let view = outlineView.makeView(withIdentifier: identifier, owner: self) as? NSTableCellView
        if let title = stringValue {
            view?.textField?.stringValue = title
        }

        return view
    }
}
