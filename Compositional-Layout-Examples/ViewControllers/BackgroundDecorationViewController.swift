//
//  BackgroundDecorationViewController.swift
//  Compositional-Layout-Examples
//
//  Created by 신소민 on 2021/10/01.
//

import UIKit

class BackgroundDecorationViewController: UIViewController {
    
    typealias DataSource = UICollectionViewDiffableDataSource<Int, String>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, String>
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private var dataSource: DataSource!

    override func viewDidLoad() {
        super.viewDidLoad()
        title  = "Section Background Example"
        
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
        collectionView.contentInset.top = 50
        collectionView.register(ItemCell.self, forCellWithReuseIdentifier: ItemCell.identifier)
        
        dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, text in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCell.identifier, for: indexPath) as! ItemCell
            cell.configure(with: text)
            return cell
        }
        dataSource.apply(createSnapshot())
    }
    
    private func createSnapshot() -> Snapshot {
        var snapshot = Snapshot()
        snapshot.appendSections([0, 1])
        
        for count in 1...15 {
            snapshot.appendItems(["Item #\(count)"], toSection: 0)
        }
        for count in 1...7 {
            snapshot.appendItems(["Item no.\(count)"], toSection: 1)
        }
        return snapshot
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout(section: createListSection())
        
        // register background view at layout
        layout.register(RoundedBackgroundView.self, forDecorationViewOfKind: RoundedBackgroundView.identifier)
        
        // setup section spacing
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        
        return layout
    }
    
    private func createListSection(withEstimatedHeight estimatedHeight: CGFloat = 100) -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1))
        )
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 15, bottom: 10, trailing: 15)
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(estimatedHeight)),
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.decorationItems = [
            NSCollectionLayoutDecorationItem.background(elementKind: RoundedBackgroundView.identifier)
        ]
        return section
    }

}
