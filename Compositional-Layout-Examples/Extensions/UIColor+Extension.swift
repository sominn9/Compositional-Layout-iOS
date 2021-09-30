//
//  UIColor+Extension.swift
//  Compositional-Layout-Examples
//
//  Created by 신소민 on 2021/09/28.
//

import UIKit

extension UIColor {
    static func random() -> UIColor {
        return UIColor(hue: CGFloat.random(in: 0...359), saturation: 0.7, brightness: 1, alpha: 1)
    }
}
