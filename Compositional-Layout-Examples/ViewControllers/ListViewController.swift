//
//  ListViewController.swift
//  Compositional-Layout-Examples
//
//  Created by 신소민 on 2021/09/28.
//

import UIKit

class ListViewController: UIViewController {
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: ListViewController.createLayout())
        collectionView.backgroundColor = .systemBackground
        return collectionView
    }()
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, UIColor>!

    static func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, env) in
            
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension : .fractionalWidth(1),
                    heightDimension: .absolute(100))
            )
            item.contentInsets.bottom = 10
            
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension : .fractionalWidth(1),
                    heightDimension: .estimated(100)),
                subitems: [item]
            )
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            return section
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "List Example"
        
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
        collectionView.register(RoundedCornerColorCell.self, forCellWithReuseIdentifier: RoundedCornerColorCell.identifier)
        
        dataSource = UICollectionViewDiffableDataSource<Int, UIColor>(collectionView: collectionView) {
            collectionView, indexPath, color in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RoundedCornerColorCell.identifier, for: indexPath)
            cell.contentView.backgroundColor = color
            return cell
        }
        // Apply the snapshot.
        dataSource.apply(createColorSnapshot())
    }
    
    private func createColorSnapshot() -> ColorSnapshot {
        var snapshot = ColorSnapshot()
        snapshot.appendSections([0])
        snapshot.addRandomItems()
        return snapshot
    }

}
