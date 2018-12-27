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

    private var partType: PartType?

    private var items = [Part]()

    override func viewDidLoad() {
        super.viewDidLoad()

        partsTableView.delegate = self
        partsTableView.dataSource = self
    }

    func partTypeDidChangeTo(_ partType: PartType) {
        self.partType = partType

        refreshData()

        partsTableView.reloadData()
    }

    private func refreshData() {
        guard let application = NSApplication.shared.delegate as? AppDelegate else {
            items = []
            return
        }

        let fetchRequest : NSFetchRequest<Resistor> = Resistor.fetchRequest()

        let context = application.persistentContainer.viewContext

        do {
            try items = context.fetch(fetchRequest)
        } catch let error as NSError {
            print(error)
            items = []
        }
    }
}

extension PartListVC: NSTableViewDelegate, NSTableViewDataSource {

    func numberOfRows(in tableView: NSTableView) -> Int {
        return items.count
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let tableColumn = tableColumn else {
            return nil
        }

        if let cell = tableView.makeView(withIdentifier: tableColumn.identifier, owner: self) as? NSTableCellView {
            cell.textField?.stringValue = String(items[row].value)
            return cell
        }

        return nil
    }
}
