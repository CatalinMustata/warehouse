//
//  PartListVC.swift
//  Warehouse
//
//  Created by Catalin Mustata on 26/12/2018.
//  Copyright © 2018 BearSoft. All rights reserved.
//

import Cocoa

class ItemListVC: NSViewController, MenuViewControllerDelegate {

    @IBOutlet weak var contentScrollView: NSScrollView!
    @IBOutlet weak var partsTableView: NSTableView!

    private var partListVM: ItemListVM<ListEntryModel>?

    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

//        partListVM = PartListVM(with: self)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
//        partListVM = PartListVM(with: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        partsTableView.delegate = self
        partsTableView.dataSource = self
    }

    func partTypeDidChangeTo(_ partType: ListEntryModel.Type) {
        partListVM = ItemListVM(of: partType)

        while let column = partsTableView.tableColumns.last {
            partsTableView.removeTableColumn(column)
        }

        partListVM?.columnList.forEach({ (identifier, title) in
            let tableColumn = NSTableColumn(identifier: identifier)
            tableColumn.title = title
            partsTableView.addTableColumn(tableColumn)
        })

        partsTableView.reloadData()
    }
}

extension ItemListVC: NSTableViewDelegate, NSTableViewDataSource {

    func numberOfRows(in tableView: NSTableView) -> Int {
        return partListVM?.viewCount ?? 0
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let tableColumn = tableColumn else {
            return nil
        }

        if let cell = tableView.makeView(withIdentifier: tableColumn.identifier, owner: self) as? NSTableCellView {
            cell.textField?.stringValue = partListVM?.textForEntry(at: row, columnIdentifier: tableColumn.identifier) ?? "-"
            return cell
        }

        return nil
    }
}
