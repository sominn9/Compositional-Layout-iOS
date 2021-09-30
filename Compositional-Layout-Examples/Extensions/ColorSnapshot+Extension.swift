//
//  ColorSnapshot+Extension.swift
//  Compositional-Layout-Examples
//
//  Created by 신소민 on 2021/09/28.
//

import UIKit

typealias ColorSnapshot = NSDiffableDataSourceSnapshot<Int, UIColor>

extension ColorSnapshot {
    mutating func addRandomItems(count: Int = 10, to section: Int? = nil) {
        var items = [UIColor]()
        for _ in 0..<count {
            items.append(UIColor.random())
        }
        if let section = section {
            self.appendItems(items, toSection: section)
        } else {
            self.appendItems(items)
        }
    }
}
