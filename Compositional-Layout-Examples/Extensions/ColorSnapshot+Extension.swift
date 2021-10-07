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
    
    mutating func addRandomItemForInfiniteScroll(count: Int = 10, to section: Int? = nil) {
        // Create random color object (uuid + uicolor)
        var items = [Color]()
        for _ in 0..<count {
            items.append(Color())
        }
        
        // To implement infinite scroll, copy items and insert into array
        if count != 1 {
            var copyLastItem = Color()
            var copyLastPrevItem = Color()
            copyLastItem.setColor(items[items.count - 1].color)
            copyLastPrevItem.setColor(items[items.count - 2].color)
            
            var copyFirstItem = Color()
            var copyFirstNextItem = Color()
            copyFirstItem.setColor(items[0].color)
            copyFirstNextItem.setColor(items[1].color)
            
            items.insert(contentsOf: [copyLastPrevItem, copyLastItem], at: 0)
            items.append(contentsOf: [copyFirstItem, copyFirstNextItem])
        }

        // Add the items at snapshot
        if let section = section {
            self.appendItems(items, toSection: section)
        } else {
            self.appendItems(items)
        }
    }
    
}
