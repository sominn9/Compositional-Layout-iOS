//
//  InteractiveHeaderView.swift
//  Compositional-Layout-Examples
//
//  Created by 신소민 on 2021/10/04.
//

import UIKit

class InteractiveHeaderView: UICollectionReusableView {
    
    let titleLabel = UILabel()
    let infoButton = UIButton()
    
    // Callback closure to handle info button tap
    var infoButtonDidTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        
        backgroundColor = .secondarySystemBackground
        
        // Add a stack view to section cotainer
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        // Adjust top anchor constant & priority
        let topAnchor = stackView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: 15)
        topAnchor.priority = UILayoutPriority(999)

        // Adjust bottom anchor constant & priority
        let bottomAnchor = stackView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor, constant: -10)
        bottomAnchor.priority = UILayoutPriority(999)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            topAnchor,
            bottomAnchor,
        ])
        
        // Set up label and add to stack view
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        stackView.addArrangedSubview(titleLabel)
        
        // Set up button and add to stack view
        let largeConfig = UIImage.SymbolConfiguration(scale: .large)
        let infoImage = UIImage(systemName: "info.circle.fill", withConfiguration: largeConfig)?
            .withTintColor(.systemPink, renderingMode: .alwaysOriginal)
        infoButton.setImage(infoImage, for: .normal)
        
        infoButton.addAction(UIAction(handler: { [unowned self] _ in
            self.infoButtonDidTapped?()
        }), for: .touchUpInside)
        
        stackView.addArrangedSubview(infoButton)
    }
    
}
