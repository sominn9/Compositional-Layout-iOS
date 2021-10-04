//
//  StickyHeaderViewController.swift
//  Compositional-Layout-Examples
//
//  Created by 신소민 on 2021/09/30.
//

import UIKit

class StickyHeaderViewController: UIViewController {

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
        title = "Sticky header example"
        
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
        collectionView.register(ItemCell.self, forCellWithReuseIdentifier: ItemCell.identifier)
        
        // Create supplementary view registration
        let headerRegistration = UICollectionView.SupplementaryRegistration<StickyHeaderView>(elementKind: UICollectionView.elementKindSectionHeader) { [unowned self] headerView, elementKind, indexPath in
            
            let sectionIdentifier = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            headerView.configure(with: "Sticky header - \(sectionIdentifier)")
        }
        
        // Set up cell provider
        dataSource = DataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, text in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCell.identifier, for: indexPath)
                    as? ItemCell  else {
                fatalError()
            }
            cell.configure(with: text)
            return cell
        })
        
        // Set up supplementary view provider
        dataSource.supplementaryViewProvider = { (collectionView, elementKind, indexPath) in
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
        
        // Apply snapshot
        dataSource.apply(createSnapshot())
    }
    
    func createSnapshot() -> Snapshot {
        var snapshot = Snapshot()
        snapshot.appendSections([1, 2, 3, 4])
        
        for count in 1...7 {
            snapshot.appendItems(["Item #\(count)"], toSection: 1)
        }
        for count in 1...6 {
            snapshot.appendItems(["Item no.\(count)"], toSection: 2)
        }
        for count in 1...6 {
            snapshot.appendItems(["Item n.\(count)"], toSection: 3)
        }
        for count in 1...6 {
            snapshot.appendItems(["#\(count) Item"], toSection: 4)
        }
        return snapshot
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let section = NSCollectionLayoutSection.listSection()
        section.decorationItems = [
            NSCollectionLayoutDecorationItem.background(elementKind: RoundedBackgroundView.identifier)
        ]
        
        let headerElement = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(50)),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        
        // This activates the sticky behavoir
        headerElement.pinToVisibleBounds = true
        
        section.boundarySupplementaryItems = [headerElement]
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 15
        
        let layout = UICollectionViewCompositionalLayout(section: section, configuration: config)
        layout.register(RoundedBackgroundView.self, forDecorationViewOfKind: RoundedBackgroundView.identifier)
        return layout
    }
    
}
