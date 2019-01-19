//
//  PartListVM.swift
//  Warehouse
//
//  Created by Catalin Mustata on 28/12/2018.
//  Copyright © 2018 BearSoft. All rights reserved.
//

import Cocoa

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
