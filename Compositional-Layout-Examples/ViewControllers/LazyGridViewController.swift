//
//  LazyGridViewController.swift
//  Compositional-Layout-Examples
//
//  Created by 신소민 on 2021/09/30.
//

import UIKit

class LazyGridViewController: UIViewController {
    
    private let maxItemCount: Int = 100
    private var loadedCount: Int = 0
    private var loadingInProgress: Bool = false
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: LazyGridViewController.createLayout())
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    var dataSource: ColorDiffableDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        dataSource = ColorDiffableDataSource(collectionView: collectionView)
        
        loadData(isInitialLoad: true)
    }
    
    static func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex: Int, env:NSCollectionLayoutEnvironment) in
            
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1/2),
                    heightDimension: .fractionalHeight(1))
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalWidth(1/2)),
                subitems: [item]
            )
            
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
    }
    
    private func setupView() {
        
        // setup collection view
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
        collectionView.delegate = self
        collectionView.contentInset.bottom = 50
        collectionView.register(RoundedCornerColorCell.self, forCellWithReuseIdentifier: RoundedCornerColorCell.identifier)
        
        // setup indicator view
        view.addSubview(loadingIndicator)
        let layoutGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor),
            loadingIndicator.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: -10)
        ])
    }
    
    private func loadData(isInitialLoad: Bool = false) {
        guard dataSource.snapshot().numberOfItems < maxItemCount else { return }
        guard !loadingInProgress else { return }
        loadingInProgress = true
        loadingIndicator.startAnimating()
        
        var snapshot: ColorSnapshot = dataSource.snapshot()
        if snapshot.numberOfItems == 0 {
            snapshot.appendSections([0])
        }
        snapshot.addRandomItems(count: 12)
        
        let loadTime: TimeInterval = isInitialLoad ? 0 : 1.4
        DispatchQueue.main.asyncAfter(deadline: .now() + loadTime) {
            self.dataSource.apply(snapshot, animatingDifferences: true)
            self.loadedCount = snapshot.numberOfItems
            self.updateTitle()
            self.loadingInProgress = false
            self.loadingIndicator.stopAnimating()
        }
    }
    
    private func updateTitle() {
        if loadedCount >= maxItemCount {
            title = "All items loaded"
        } else {
            title = "Loaded \(loadedCount) items"
        }
    }
    
}

extension LazyGridViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard loadedCount != 0 else { return }
        
        if indexPath.row == loadedCount - 1 {
            loadData()
        }
    }
}
