//
//  ColorCell.swift
//  Compositional-Layout-Examples
//
//  Created by 신소민 on 2021/09/28.
//

import UIKit

class RoundedCornerColorCell: UICollectionViewCell {
    
    static let identifier = "RoundedCornerColorCell"
    
    override var isHighlighted: Bool {
        didSet {
            contentView.alpha = isHighlighted ? 0.7 : 1.0
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = 10
    }
    
}
