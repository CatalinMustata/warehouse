//
//  PartListVC.swift
//  Warehouse
//
//  Created by Catalin Mustata on 26/12/2018.
//  Copyright © 2018 BearSoft. All rights reserved.
//

import Cocoa

class PartListVC: NSViewController, MenuViewControllerDelegate {

    @IBOutlet weak var contentScrollView: NSScrollView!
    @IBOutlet weak var partsTableView: NSTableView!

//    private var partType: PartType?

    private var partListVM: PartListVM

    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        partListVM = PartListVM()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        partListVM.partListVC = self
    }

    required init?(coder: NSCoder) {
        partListVM = PartListVM()

        super.init(coder: coder)

        partListVM.partListVC = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        partsTableView.delegate = self
        partsTableView.dataSource = self
    }

    func partTypeDidChangeTo(_ partType: PartModel.Type) {
//        self.partType = partType

        partListVM.partType = partType

        partsTableView.reloadData()
    }
}

extension PartListVC: NSTableViewDelegate, NSTableViewDataSource {

    func numberOfRows(in tableView: NSTableView) -> Int {
        return partListVM.partCount
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let tableColumn = tableColumn else {
            return nil
        }

        if let cell = tableView.makeView(withIdentifier: tableColumn.identifier, owner: self) as? NSTableCellView {
            cell.textField?.stringValue = partListVM.item(at: row)?.displayValueString ?? "0"
            return cell
        }

        return nil
    }
}
