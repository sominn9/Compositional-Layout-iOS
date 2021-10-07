//
//  Color.swift
//  Compositional-Layout-Examples
//
//  Created by 신소민 on 2021/09/30.
//

import UIKit

struct Color: Hashable {
    let id = UUID()
    var color = UIColor.random()
    
    mutating func setColor(_ color: UIColor) {
        self.color = color
    }
}
