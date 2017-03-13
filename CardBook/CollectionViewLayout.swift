//
//  CollectionViewLayout.swift
//  CardBook
//
//  Created by Hale on 2017/3/12.
//  Copyright © 2017年 Hale. All rights reserved.
//

import UIKit

class CollectionViewLayout: UICollectionViewFlowLayout {
    var visibleCount = 3
    var cellCount: Int!
    var margin: CGFloat = 15
    
    override func prepare() {
        super.prepare()
        cellCount = collectionView!.numberOfItems(inSection: 0)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: collectionView!.frame.width, height: itemSize.height + CGFloat(cellCount - visibleCount) * margin)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var array = [UICollectionViewLayoutAttributes]()
        for i in 0..<cellCount {
            let indexPath = IndexPath(item: i, section: 0)
            let attributes = layoutAttributesForItem(at: indexPath)!
            array.append(attributes)
        }
        return array
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.size = itemSize
        let baseCenterY = itemSize.height / 2 + CGFloat(indexPath.row) * margin
        var centerY = baseCenterY
        attributes.zIndex = indexPath.row
//        let offsetY = margin * CGFloat(cellCount - visibleCount) - collectionView!.contentOffset.y
        let delta = centerY - collectionView!.contentOffset.y - itemSize.height / 2
        let ratio = pow(delta / margin, 3) / 20
        let offset = ratio * itemSize.height / 2
        var scale = 0.9 + 1.0 * ratio
        centerY = baseCenterY + offset
        print("delta:\(delta) row:\(indexPath.row)")
        if delta < 0 {
            centerY = collectionView!.contentOffset.y + itemSize.height / 2
        }
        if scale > 1 { scale = 1}
//        attributes.transform = CGAffineTransform(scaleX: scale, y: scale)
        attributes.center = CGPoint(x: collectionView!.frame.width / 2, y: centerY)
        return attributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
