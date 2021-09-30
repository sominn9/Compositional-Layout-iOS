//
//  ResponsiveLayoutViewController.swift
//  Compositional-Layout-Examples
//
//  Created by 신소민 on 2021/09/30.
//

import UIKit

class ResponsiveGridViewController: UIViewController {

    private var collectionView: UICollectionView!
    
    private var dataSource: ColorDiffableDataSource!
    
    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, env in
            
            let desiredWidth: CGFloat = 230
            
            let itemCount = (env.container.effectiveContentSize.width / desiredWidth).rounded()            
                        
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1 / itemCount),
                    heightDimension: .fractionalHeight(1)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalWidth(1 / itemCount)),
                subitems: [item]
            )
            
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Responsive Layout"

        // UICollectionView
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
        collectionView.register(RoundedCornerColorCell.self, forCellWithReuseIdentifier: RoundedCornerColorCell.identifier)
        
        configureDataSource()
    }
    
    private func configureDataSource() {
        dataSource = ColorDiffableDataSource(collectionView: collectionView)
        dataSource.apply(ColorSnapshot.random())
    }

}
