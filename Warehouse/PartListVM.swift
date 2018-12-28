//
//  PartListVM.swift
//  Warehouse
//
//  Created by Catalin Mustata on 28/12/2018.
//  Copyright © 2018 BearSoft. All rights reserved.
//

import Cocoa

struct PartList<T: PartModel> {

    private(set) var items: [T]?

    init(with partType: PartModel.Type?) {
        guard let application = NSApplication.shared.delegate as? AppDelegate,
              let type = partType else {
            items = []
            return
        }

        let fetchRequest = NSFetchRequest<T>(entityName: type.entityName)

        let context = application.persistentContainer.viewContext

        do {
            try items = context.fetch(fetchRequest)
        } catch let error as NSError {
            print(error)
            items = []
        }
    }
}

final class PartListVM {
    weak var partListVC: PartListVC?

    private var partList: PartList<PartModel>?

    var partType: PartModel.Type? {
        didSet {
            partList = PartList(with: partType)
        }
    }

    var partCount: Int {
        return partList?.items?.count ?? 0
    }

    func item(at index: Int) -> PartModel? {
        return partList?.items?[index]
    }
}
