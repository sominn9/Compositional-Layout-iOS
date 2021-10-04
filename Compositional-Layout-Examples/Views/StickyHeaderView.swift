//
//  StickyHeaderView.swift
//  Compositional-Layout-Examples
//
//  Created by 신소민 on 2021/10/05.
//

import UIKit

class StickyHeaderView: HeaderView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        super.label.textColor = .black
        backgroundColor = .systemOrange
    }
}
