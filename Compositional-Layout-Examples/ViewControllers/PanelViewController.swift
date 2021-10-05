//
//  PanelViewController.swift
//  Compositional-Layout-Examples
//
//  Created by 신소민 on 2021/10/05.
//

import UIKit

class PanelViewController: UIViewController {

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private var dataSource: ColorDiffableDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Onboarding Example"
        
        // Set up collection view
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
        collectionView.contentInset.top = 10
        collectionView.alwaysBounceVertical = false
        collectionView.register(RoundedCornerColorCell.self, forCellWithReuseIdentifier: RoundedCornerColorCell.identifier)
        
        // Make diffable data source and apply
        dataSource = ColorDiffableDataSource(collectionView: collectionView)
        dataSource.apply(createSnapshot())
    }
    
    private func createSnapshot() -> ColorSnapshot {
        var snapshot = ColorSnapshot()
        snapshot.appendSections([0])
        snapshot.addRandomItems()
        return snapshot
    }
    
    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, env in
            
            let fractionalWidth = 0.9
            let contentInset = 10.0
            let sectionInset = (env.container.effectiveContentSize.width * (1-fractionalWidth)) / 2
            
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)))
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(fractionalWidth),
                    heightDimension: .absolute(130)),
                subitems: [item])
            group.contentInsets.leading = contentInset
            group.contentInsets.trailing = contentInset
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets.leading = sectionInset.rounded()
            section.contentInsets.trailing = sectionInset.rounded()
            section.orthogonalScrollingBehavior = .groupPaging
            return section
        }
    }
    
}
