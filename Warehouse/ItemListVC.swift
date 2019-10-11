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
    @IBOutlet weak var removeItemButton: NSButton!
    
    private var partListVM: ItemListVM<ListEntryModel>?

    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        partsTableView.delegate = self
        partsTableView.dataSource = self
    }


    @IBAction func didTapAddItem(_ sender: Any) {
        guard let viewModel = partListVM else {
            return
        }

        viewModel.addNewEntry()
        partsTableView.reloadData()
        updateRemoveButtonState()
        
        let newRowIndex = viewModel.viewCount - 1
        partsTableView.selectRowIndexes(IndexSet(arrayLiteral: newRowIndex), byExtendingSelection: false)
        partsTableView.editColumn(0, row: newRowIndex, with: nil, select: true)
    }

    @IBAction func didTapRemoveItem(_ sender: Any) {
        guard let viewModel = partListVM else {
            return
        }

        viewModel.removeEntryAt(partsTableView.selectedRow)
        updateRemoveButtonState()
        partsTableView.reloadData()
    }
    
    func partTypeDidChangeTo(_ partType: ListEntryModel.Type) {
        partListVM = ItemListVM(of: partType)

        partsTableView.reloadData()
        updateRemoveButtonState()
        // it's mandatory to issue the reconfigure call after reloading data in order to
        // set the correct data set size for the table view
        reconfigureColumns()
    }

    private func reconfigureColumns() {
        while let column = partsTableView.tableColumns.last {
            partsTableView.removeTableColumn(column)
        }

        partListVM?.columnList.forEach({ (identifier, title) in
            let tableColumn = NSTableColumn(identifier: identifier)
            tableColumn.title = title
            partsTableView.addTableColumn(tableColumn)
        })
    }

    private func updateRemoveButtonState() {
        removeItemButton.isEnabled = (self.partListVM?.viewCount ?? 0) > 0
    }
}

extension ItemListVC: NSTableViewDelegate, NSTableViewDataSource {

    func numberOfRows(in tableView: NSTableView) -> Int {
        return partListVM?.viewCount ?? 0
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let columnIdentifier = tableColumn?.identifier, let cellIdentifier = ColumnMapping.representationFor[columnIdentifier] else {
            return nil
        }

        if let cell = tableView.makeView(withIdentifier: cellIdentifier, owner: self) {
            if cellIdentifier == TableCellIdentifiers.defaultTextCell, let textCell = cell as? NSTableCellView {
                textCell.textField?.stringValue = partListVM?.textForEntry(at: row, columnIdentifier: columnIdentifier) ?? "-"
                textCell.textField?.delegate = self
            } else if cellIdentifier == TableCellIdentifiers.defaultComboCell, let comboCell = cell as? ComboTableCellView {
                comboCell.comboBox.stringValue = partListVM?.textForEntry(at: row, columnIdentifier: columnIdentifier) ?? "-"
                comboCell.comboBox.dataSource = ManufacturerProvider.sharedInstance
                comboCell.comboBox.delegate = self
            }

            return cell
        }

        return nil
    }
}

extension ItemListVC: NSTextFieldDelegate, NSComboBoxDelegate {
    func controlTextDidEndEditing(_ obj: Notification) {
        guard let textField = obj.object as? NSTextField else {
            return
        }

        let row = partsTableView.row(for: textField)
        let column = partsTableView.column(for: textField)
        let identifier = partsTableView.tableColumns[column].identifier

        guard row != -1 && column != -1, let field = ColumnMapping.forIdentifier[identifier] else {
            print("Invalid field (\(row):\(column))")
            return
        }

        // TODO: Add error handling
        _ = partListVM?.updateItem(at: row, setting: field, to: textField.stringValue)

        textField.stringValue = partListVM?.textForEntry(at: row, columnIdentifier: identifier) ?? "-"
    }
}
