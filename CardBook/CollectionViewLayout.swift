//
//  CollectionViewLayout.swift
//  CardBook
//
//  Created by Hale on 2017/3/8.
//  Copyright © 2017年 Hale. All rights reserved.
//
import UIKit

protocol CollectionViewLayoutDelegate {
    func didRemoveItem(at indexPath: IndexPath)
}

class CollectionViewLayout: UICollectionViewFlowLayout {
    var visibleCount = 3
    var cellCount: Int!
    var minMargin: CGFloat = 15
    var maxMargin: CGFloat!
    
    override func prepare() {
        super.prepare()
        cellCount = collectionView!.numberOfItems(inSection: 0)
        maxMargin = itemSize.height / 3
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: collectionView!.frame.width, height: itemSize.height + maxMargin * CGFloat(cellCount - 1))
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
        let offsetY = collectionView!.contentOffset.y
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        let scrollPercent = offsetY / (itemSize.height + maxMargin * CGFloat(cellCount - 1))
        print(scrollPercent)
        let margin = maxMargin - (maxMargin - minMargin) * scrollPercent
        attributes.size = itemSize
        let baseCenterY = itemSize.height / 2 + CGFloat(indexPath.row) * margin
        attributes.zIndex = indexPath.row
        attributes.center = CGPoint(x: collectionView!.frame.width / 2, y: baseCenterY)
        return attributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}


//if collectionView!.contentOffset.y >= 0 {
//    collectionView!.contentInset = .zero
//} else {
//    collectionView!.contentInset = UIEdgeInsets(top: CGFloat(visibleCount) * margin, left: 0, bottom: 0, right: 0)
//}
//attributes.size = itemSize
//let baseCenterY = itemSize.height / 2 + CGFloat(indexPath.row) * margin
//var centerY = baseCenterY
//attributes.zIndex = indexPath.row
//let offsetY = margin * CGFloat(cellCount - visibleCount) - collectionView!.contentOffset.y
//let delta = centerY - collectionView!.contentOffset.y - itemSize.height / 2
//let ratio = delta / margin
//if ratio > 0 {
//    let offset = pow(ratio, 3) / 20 * offsetY
//    centerY = baseCenterY + offset
//}
//if delta < 0 {
//    centerY = collectionView!.contentOffset.y + itemSize.height / 2
//    if indexPath.row < cellCount - visibleCount {
//        attributes.alpha = delta > -margin ? 1 : 0
//    }
//}
//if centerY - collectionView!.contentOffset.y > itemSize.height / 2 + maxHeight * CGFloat(indexPath.row) {
//    centerY = itemSize.height / 2 + CGFloat(indexPath.row) *  maxHeight + collectionView!.contentOffset.y
//}
//var r = delta / (CGFloat(visibleCount) * margin)
//if r < 0 { r = 0 }
//if r > 1 { r = 1 }
//let scale = 0.9 + r * 0.1
//let scaleDeltaY = (1 - scale) * itemSize.height / 2
//if scaleDeltaY > 0 {
//    centerY -= scaleDeltaY
//}
//attributes.transform = CGAffineTransform(scaleX: scale, y: scale)
//attributes.center = CGPoint(x: collectionView!.frame.width / 2, y: centerY+sectionInset.top)
//if collectionView!.contentOffset.y + collectionView!.contentInset.top <= 0 {
//    attributes.center.y = attributes.center.y - collectionView!.contentOffset.y - collectionView!.contentInset.top
//}
