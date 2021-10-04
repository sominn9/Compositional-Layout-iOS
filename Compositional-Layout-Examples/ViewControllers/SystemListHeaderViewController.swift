//
//  SystemListHeaderViewController.swift
//  Compositional-Layout-Examples
//
//  Created by 신소민 on 2021/10/04.
//

import UIKit

@available(iOS 14.0, tvOS 14.0, *)
class SystemListHeaderViewController: UIViewController {

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
    
    private let defaultAppearance: ListAppearance = .allOptions[1]
    
    private var dataSource: ColorDiffableDataSource!
    
    //MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "System List Example"
        
        // Set up collection view
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
        collectionView.contentInset.top = 10
        collectionView.register(RoundedCornerColorCell.self, forCellWithReuseIdentifier: RoundedCornerColorCell.identifier)
        
        // Set up collection view data
        dataSource = ColorDiffableDataSource(collectionView: collectionView)
        loadData()
        
        // Set up navigation bar item
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .edit, primaryAction: nil, menu: menu)
        
        // Create a registration object
        let headerRegistration = UICollectionView.SupplementaryRegistration
        <InteractiveHeaderView>(elementKind: UICollectionView.elementKindSectionHeader) { [unowned self] headerView, elementKind, indexPath in
            
            let sectionIdentifier = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            headerView.titleLabel.text = "Section - \(sectionIdentifier)"
            
            headerView.infoButtonDidTapped = { [unowned self] in
                let alert = UIAlertController(title: "Info", message: "Yeah~", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okAction)
                
                self.present(alert, animated: true)
            }
        }
        
        // Define the data source's supplementary view provider
        dataSource.supplementaryViewProvider = { (collectionView, elementKind, indexPath) in
            collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
    }
    
    private func loadData() {
        var snapshot = ColorSnapshot()
        snapshot.appendSections([0, 1, 2])
        snapshot.addRandomItems(count: 7, to: 0)
        snapshot.addRandomItems(count: 8, to: 1)
        snapshot.addRandomItems(count: 10, to: 2)
        dataSource.apply(snapshot)
    }
    
    private func setAppearance(_ appearance: ListAppearance) {
        collectionView.setCollectionViewLayout(createLayout(appearance), animated: true)
    }

    private func createLayout(_ appearance: ListAppearance) -> UICollectionViewLayout {
        var layoutConfig = UICollectionLayoutListConfiguration(appearance: appearance.appearance)
        layoutConfig.headerMode = .supplementary
        return UICollectionViewCompositionalLayout.list(using: layoutConfig)
    }
    
}
