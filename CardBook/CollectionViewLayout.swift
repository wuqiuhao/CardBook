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
    var maxHeight: CGFloat!
    
    override func prepare() {
        super.prepare()
        cellCount = collectionView!.numberOfItems(inSection: 0)
        collectionView!.contentInset = UIEdgeInsets(top: margin * CGFloat(visibleCount), left: 0, bottom: 0, right: 0)
        maxHeight = itemSize.height / 3
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: collectionView!.frame.width, height: collectionView!.frame.height + CGFloat(cellCount - visibleCount) * margin)
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
        print(collectionView!.contentOffset.y)
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.size = itemSize
        let baseCenterY = itemSize.height / 2 + CGFloat(indexPath.row) * margin
        var centerY = baseCenterY
        attributes.zIndex = indexPath.row
        let offsetY = margin * CGFloat(cellCount - visibleCount) - collectionView!.contentOffset.y
        let delta = centerY - collectionView!.contentOffset.y - itemSize.height / 2
        let ratio = delta / margin
        if ratio > 0 {
            let offset = pow(ratio, 3) / 20 * offsetY
            centerY = baseCenterY + offset
        }
        if delta < 0 {
            centerY = collectionView!.contentOffset.y + itemSize.height / 2
            if indexPath.row < cellCount - visibleCount {
                attributes.alpha = delta > -margin ? 1 : 0
            }
        }
        if centerY - collectionView!.contentOffset.y > itemSize.height / 2 + maxHeight * CGFloat(indexPath.row) {
            centerY = itemSize.height / 2 + CGFloat(indexPath.row) *  maxHeight + collectionView!.contentOffset.y
        }
        var r = delta / (CGFloat(visibleCount) * margin)
        if r < 0 { r = 0 }
        if r > 1 { r = 1 }
        let scale = 0.9 + r * 0.1
        let scaleDeltaY = (1 - scale) * itemSize.height / 2
        if scaleDeltaY > 0 {
            centerY -= scaleDeltaY
        }
        attributes.transform = CGAffineTransform(scaleX: scale, y: scale)
        attributes.center = CGPoint(x: collectionView!.frame.width / 2, y: centerY)
        return attributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
