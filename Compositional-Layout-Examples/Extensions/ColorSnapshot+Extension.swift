//
//  ColorSnapshot+Extension.swift
//  Compositional-Layout-Examples
//
//  Created by 신소민 on 2021/09/28.
//

import UIKit

typealias ColorSnapshot = NSDiffableDataSourceSnapshot<Int, Color>

extension ColorSnapshot {
    
    static func random() -> ColorSnapshot {
        var snapshot = ColorSnapshot()
        snapshot.appendSections([0])
        snapshot.addRandomItems()
        return snapshot
    }
    
    mutating func addRandomItems(count: Int = 10, to section: Int? = nil) {
        var items = [Color]()
        for _ in 0..<count {
            items.append(Color())
        }
        if let section = section {
            self.appendItems(items, toSection: section)
        } else {
            self.appendItems(items)
        }
    }
    
}
