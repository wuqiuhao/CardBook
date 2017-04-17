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
    var marginNum: Int!
    
    func config() {
        collectionView!.scrollToItem(at: IndexPath(row: collectionView!.numberOfItems(inSection: 0) - 1, section: 0), at: .bottom, animated: false)
    }
    
    override func prepare() {
        super.prepare()
        cellCount = collectionView!.numberOfItems(inSection: 0)
        maxMargin = itemSize.height / 2
        if cellCount > visibleCount {
            marginNum = visibleCount - 1
        } else {
            marginNum = cellCount - 1
        }
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: collectionView!.frame.width, height: itemSize.height + maxMargin * CGFloat(cellCount - 1))
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var array = [UICollectionViewLayoutAttributes]()
        let start = 0
        let end = cellCount!
        
        for i in start..<end {
            let indexPath = IndexPath(item: i, section: 0)
            let attributes = layoutAttributesForItem(at: indexPath)!
            array.append(attributes)
        }
        return array
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let offsetY = collectionView!.contentOffset.y
        if offsetY < 0 {
            collectionView!.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0)
        }
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.size = itemSize
        let baseCenterY = itemSize.height / 2 + CGFloat(indexPath.row) * maxMargin
        var centerY = baseCenterY
        let baseY = itemSize.height / 2 + offsetY
        let dy = baseCenterY - baseY
        
        var i: Int!
        var d = cellCount - visibleCount
        if d < 0 { d = 0 }
        if indexPath.row >= d {
            i = indexPath.row - d
        } else {
            i = 0
        }
        let minCenterY = CGFloat(i) * minMargin + itemSize.height / 2 + offsetY
        let cellBaseScale = 0.95 + (CGFloat(i) * minMargin) / (CGFloat(marginNum) * minMargin) * 0.05
        
        var x = dy / itemSize.height * 3
        if x < 0 { x = 0 }
        centerY = itemSize.height / 2 + (80 / 3) * pow(x, 2) + (160 / 3) * x + offsetY

        if centerY < minCenterY {
            centerY = minCenterY
        }
        
        let hideIndex = Int(offsetY / maxMargin)
        if visibleCount < cellCount && indexPath.row < cellCount - visibleCount {
            if indexPath.row < hideIndex {
                attributes.alpha = 0
            }
        }
        
        // scale
        var k = (dy + 120) / itemSize.height * 3
        if k < 0 { k = 0 }
        if k > 1 { k = 1 }
        var scale = 0.95 + k * 0.05
        if scale < cellBaseScale {
            scale = cellBaseScale
        }
        let scaleDeltaY = (1 - scale) * itemSize.height / 2
        if scaleDeltaY > 0 {
            centerY -= scaleDeltaY
        }
        attributes.transform = CGAffineTransform(scaleX: scale, y: scale)
        
        // 上拉吸附
        let maxOffsetY = maxMargin * CGFloat(cellCount - 1) - CGFloat(marginNum) * minMargin
        if offsetY > maxOffsetY {
            centerY -= offsetY - maxOffsetY
        }
        
        attributes.zIndex = indexPath.row
        attributes.center = CGPoint(x: collectionView!.frame.width / 2, y: centerY)
        return attributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
