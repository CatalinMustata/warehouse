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

    init(of partType: T.Type) {
        guard let application = NSApplication.shared.delegate as? AppDelegate else {
            items = []
            return
        }

        let fetchRequest = NSFetchRequest<T>(entityName: partType.entityName)

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

    init(with viewController: PartListVC) {
        partListVC = viewController
    }

    var partType: PartModel.Type? {
        didSet {
            guard let type = partType else {
                partList = nil
                return
            }

            partList = PartList(of: type)
        }
    }

    var partCount: Int {
        return partList?.items?.count ?? 0
    }

    func item(at index: Int) -> PartModel? {
        return partList?.items?[index]
    }
}
