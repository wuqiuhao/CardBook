//
//  CollectionViewLayout.swift
//  CardBook
//
//  Created by Hale on 2017/3/12.
//  Copyright © 2017年 Hale. All rights reserved.
//

import UIKit

class CollectionViewLayout: UICollectionViewLayout {
    var itemSize: CGSize!
    var visibleCount = 3
    var cellCount: Int!
    var margin: CGFloat = 15
    
    override func prepare() {
        super.prepare()
        cellCount = collectionView!.numberOfItems(inSection: 0)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: collectionView!.frame.width, height: itemSize.height + CGFloat(cellCount - 1) * margin)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var array = [UICollectionViewLayoutAttributes]()
        let offsetY = CGFloat(cellCount - visibleCount + 1) * margin - collectionView!.contentOffset.y
        var begin = cellCount - visibleCount
        var end = cellCount!
        if offsetY > 0 {
            begin = max(cellCount - visibleCount - Int(offsetY / margin) , 0)
            end = min(cellCount,cellCount + visibleCount)
        }
        for i in begin..<end {
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
        let cY = itemSize.height / 2 + collectionView!.contentOffset.y
        let offsetY = CGFloat(cellCount - visibleCount) * margin - collectionView!.contentOffset.y
        var delta = centerY - cY
        let ratio = delta / margin
        if offsetY >= 0 {
            if ratio <= 0 {
                attributes.alpha = ratio + 1
            }
        }
        let n = CGFloat(visibleCount - 1)
        if ratio > n {
            let offset = (ratio - n) * delta
            centerY = offset + baseCenterY
        }
        if delta < 0 { delta = 0 }
        var scale = delta / 70 * 0.1 + 0.9
        if scale > 1 { scale = 1 }
        attributes.transform = CGAffineTransform(scaleX: scale, y: 1)
//        print("delta:\(delta) offsetY:\(offsetY) row:\(indexPath.row)")
        attributes.zIndex = indexPath.row
        attributes.center = CGPoint(x: collectionView!.frame.width / 2, y: centerY)
        return attributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
