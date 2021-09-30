//
//  ResizableGridViewController.swift
//  Compositional-Layout-Examples
//
//  Created by 신소민 on 2021/09/30.
//

import UIKit

class ResizableGridViewController: UIViewController {
    
    enum GridItemSize: CGFloat {
        case half = 0.5
        case third = 0.33333
        case quarter = 0.25
    }
    
    private var collectionView: UICollectionView!
    
    var dataSource: ColorDiffableDataSource!
    
    var gridItemSize: GridItemSize = .half {
        didSet {
            collectionView.setCollectionViewLayout(createLayout(), animated: true)
        }
    }
    
    lazy var sizeMenu: UIMenu = { [unowned self] in
        return UIMenu(title: "Select size", image: nil, identifier: nil, options: [.displayInline], children: [
            UIAction(title: "Half", image: UIImage(systemName: "square.grid.2x2.fill"), handler: { _ in
                self.gridItemSize = .half
            }),
            UIAction(title: "Third", image: UIImage(systemName: "square.grid.3x2.fill"), handler: { _ in
                self.gridItemSize = .third
            }),
            UIAction(title: "Quarter", image: UIImage(systemName: "square.grid.4x3.fill"), handler: { _ in
                self.gridItemSize = .quarter
            })
        ])
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Simple Grid Example"
        
        setupView()
        
        configureDataSource()
        
        if #available(iOS 14.0, *) {
            navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .edit, primaryAction: nil, menu: sizeMenu)
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(showSizeSelection))
        }
    }
    
    private func setupView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
        collectionView.register(RoundedCornerColorCell.self, forCellWithReuseIdentifier: RoundedCornerColorCell.identifier)
    }
    
    private func configureDataSource() {
        dataSource = ColorDiffableDataSource(collectionView: collectionView)
        dataSource.apply(ColorSnapshot.random())
    }
    
    @objc func showSizeSelection() {
        let alert = UIAlertController(title: "Select size", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Half", style: .default, handler: { _ in
            self.gridItemSize = .half
        }))
        alert.addAction(UIAlertAction(title: "Third", style: .default, handler: { _ in
            self.gridItemSize = .third
        }))
        alert.addAction(UIAlertAction(title: "Quarter", style: .default, handler: { _ in
            self.gridItemSize = .quarter
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true)
    }
    
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [unowned self] (sectionIndex, env) in
                        
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(self.gridItemSize.rawValue),
                    heightDimension: .fractionalHeight(1))
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalWidth(self.gridItemSize.rawValue)),
                subitems: [item]
            )
            
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
    }
    
}
