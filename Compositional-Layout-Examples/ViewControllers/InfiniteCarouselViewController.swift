//
//  InfiniteCarouselViewController.swift
//  Compositional-Layout-Examples
//
//  Created by 신소민 on 2021/10/05.
//

import UIKit

class InfiniteCarouselViewController: UIViewController {

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private var dataSource: ColorDiffableDataSource!
    private var shownItems: [IndexPath] = []
    
    private var isShownItemsCompletelyChanged: Bool = false {
        didSet {
            if isDraggingEnd && isShownItemsCompletelyChanged {
                scrollToSameItem()
            }
        }
    }
    private var isDraggingEnd: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Infinite Carousel Example"
        
        // Set up collection view
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.frame = view.bounds
        collectionView.contentInset.top = 10
        collectionView.alwaysBounceVertical = false
        collectionView.register(RoundedCornerColorCell.self, forCellWithReuseIdentifier: RoundedCornerColorCell.identifier)
        
        // Make diffable data source and apply
        dataSource = ColorDiffableDataSource(collectionView: collectionView)
        dataSource.apply(createSnapshot())
        
        // Set the items the collection view will show first
        collectionView.scrollToItem(at: IndexPath(row: 2, section: 0), at: .centeredVertically, animated: false)
        
        // Add swipe gesture recognizer
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureHandler(_:)))
        recognizer.delegate = self
        collectionView.addGestureRecognizer(recognizer)
        collectionView.isUserInteractionEnabled = true
    }
    
    private func createSnapshot() -> ColorSnapshot {
        var snapshot = ColorSnapshot()
        snapshot.appendSections([0])
        snapshot.addRandomItemForInfiniteScroll(count: 3)
        return snapshot
    }
    
    @objc func panGestureHandler(_ gestureRecognizer :UIPanGestureRecognizer) {
        // If dragging is finished and the item on the screen is completely changed, scroll to another item
        if gestureRecognizer.state == .ended {
            isDraggingEnd = true
            if isShownItemsCompletelyChanged {
                scrollToSameItem()
            }
        } else {
            isDraggingEnd = false
        }
    }
    
    func scrollToSameItem() {
        if self.shownItems[1] == IndexPath(row: 1, section: 0) {
            // row 1 to row 4
            self.collectionView.scrollToItem(at: IndexPath(row: 4, section: 0), at: .centeredVertically, animated: false)
        } else if self.shownItems[1] == IndexPath(row: 5, section: 0) {
            // row 5 to row 2 (bug..... why IndexPath(row: 2, section: 0) does not work properly)
            self.collectionView.scrollToItem(at: IndexPath(row: 2 + 1, section: 0), at: .centeredVertically, animated: false)
        }
        self.dataSource.apply(self.dataSource.snapshot(), animatingDifferences: false)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, env in
            
            let fractionalWidth = 0.9
            let contentInset = 10.0
            let sectionInset = env.container.effectiveContentSize.width * (1-fractionalWidth) / 2
            
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
            
            section.visibleItemsInvalidationHandler = { visibleItems, scrollOffset, layoutEnvironment in
                // Print current position
                let criteria = layoutEnvironment.container.effectiveContentSize.width * fractionalWidth
                print("row: ", round(scrollOffset.x / criteria))
            }
            
            return section
        }
    }
    
}

// MARK: - UICollectionViewDelegate

extension InfiniteCarouselViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        shownItems.append(indexPath)
        shownItems.sort()
        
        if shownItems.count == 3 {
            isShownItemsCompletelyChanged = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let index = shownItems.firstIndex(of: indexPath) {
            shownItems.remove(at: index)
            
            if shownItems.count != 3 {
                isShownItemsCompletelyChanged = false
            }
        }
    }

}

// MARK: - UIGestureRecognizerDelegate

extension InfiniteCarouselViewController: UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}
