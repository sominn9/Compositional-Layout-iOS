//
//  SystemListSwipeViewController.swift
//  Compositional-Layout-Examples
//
//  Created by 신소민 on 2021/10/02.
//

import UIKit

@available(iOS 14.0, tvOS 14.0, *)
class SystemListSwipeViewController: UIViewController {

    struct ListAppearance {
        let name: String
        let appearance: UICollectionLayoutListConfiguration.Appearance
        
        static let allOptions: [ListAppearance] = [
            ListAppearance(name: "Plain", appearance: .plain),
            ListAppearance(name: "Grouped", appearance: .grouped),
            ListAppearance(name: "Inset Grouped", appearance: .insetGrouped),
            ListAppearance(name: "Sidebar", appearance: .sidebar),
            ListAppearance(name: "Sidebar plain", appearance: .sidebarPlain)
        ]
    }
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout(defaultAppearance))
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private lazy var menu: UIMenu = { [unowned self] in
        let children = ListAppearance.allOptions.map { listAppearance in
            UIAction(title: listAppearance.name, handler: { _ in
                self.setAppearance(listAppearance)
            })
        }
        return UIMenu(title: "Select appearance", image: nil, identifier: nil, options: [.displayInline], children: children)
    }()
    
    private let defaultAppearance: ListAppearance = .allOptions.first!
    
    private var dataSource: ColorDiffableDataSource!
    
    //MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "System List Example"
        
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
        collectionView.contentInset.top = 10
        collectionView.register(RoundedCornerColorCell.self, forCellWithReuseIdentifier: RoundedCornerColorCell.identifier)
        
        dataSource = ColorDiffableDataSource(collectionView: collectionView)
        loadData()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .edit, primaryAction: nil, menu: menu)
    }
    
    private func loadData() {
        var snapshot = ColorSnapshot()
        snapshot.appendSections([0, 1, 2])
        snapshot.addRandomItems(count: 10, to: 0)
        snapshot.addRandomItems(count: 10, to: 1)
        snapshot.addRandomItems(count: 10, to: 2)
        
        dataSource.apply(snapshot)
    }
    
    private func setAppearance(_ appearance: ListAppearance) {
        collectionView.setCollectionViewLayout(createLayout(appearance), animated: true)
    }

    private func createLayout(_ appearance: ListAppearance) -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, env in
            
            var config = UICollectionLayoutListConfiguration(appearance: appearance.appearance)
            
            // Add swipe action to list
            config.leadingSwipeActionsConfigurationProvider = { [weak self] (indexPath) in
                guard let self = self else { return nil }
                guard let item = self.dataSource.itemIdentifier(for: indexPath) else { return nil }
                return self.leadingSwipeActionConfigurationForListCellItem(item)
            }
            
            return NSCollectionLayoutSection.list(
                using: config,
                layoutEnvironment: env)
        }
    }

    private func leadingSwipeActionConfigurationForListCellItem(_ item: Color) -> UISwipeActionsConfiguration {
        let action = UIContextualAction(style: .normal, title: "스와이프!", handler: { action, view, completionHandler in
            print("Action performed! Color: \(item.color)")
            completionHandler(true)
        })
        return UISwipeActionsConfiguration(actions: [action])
    }
}

