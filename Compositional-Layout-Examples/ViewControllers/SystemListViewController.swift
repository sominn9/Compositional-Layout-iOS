//
//  SystemListViewController.swift
//  Compositional-Layout-Examples
//
//  Created by 신소민 on 2021/10/02.
//

import UIKit

@available(iOS 14.0, tvOS 14.0, *)
class SystemListViewController: UIViewController {

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
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(showApperanceDialog))
    }
    
    private func loadData() {
        var snapshot = ColorSnapshot()
        snapshot.appendSections([0, 1, 2])
        snapshot.addRandomItems(count: 10, to: 0)
        snapshot.addRandomItems(count: 10, to: 1)
        snapshot.addRandomItems(count: 10, to: 2)
        
        dataSource.apply(snapshot)
    }
    
//    @objc private func showApperanceDialog() {
//        let alert = UIAlertController(title: "Select appearance", message: nil, preferredStyle: .alert)
//
//        for option in ListAppearance.allOptions {
//            alert.addAction(UIAlertAction(title: option.name, style: .default, handler: { _ in
//                self.setAppearance(option)
//            }))
//        }
//
//        alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
//        present(alert, animated: true, completion: nil)
//    }
    
    private func setAppearance(_ appearance: ListAppearance) {
        collectionView.setCollectionViewLayout(createLayout(appearance), animated: true)
    }

    private func createLayout(_ appearance: ListAppearance) -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: appearance.appearance)
        return UICollectionViewCompositionalLayout.list(using: config)
    }
    
}
