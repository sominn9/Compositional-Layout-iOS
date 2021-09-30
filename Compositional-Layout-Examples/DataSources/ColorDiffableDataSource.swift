//
//  ColorDiffableDataSource.swift
//  Compositional-Layout-Examples
//
//  Created by 신소민 on 2021/09/30.
//

import UIKit

class ColorDiffableDataSource: UICollectionViewDiffableDataSource<Int, Color> {
    
    init(collectionView: UICollectionView) {
        super.init(collectionView: collectionView) { (collectionView, indexPath, color) in
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RoundedCornerColorCell.identifier,
                for: indexPath
            )
            print(color)
            cell.contentView.backgroundColor = color.color
            return cell
        }
    }
    
}
