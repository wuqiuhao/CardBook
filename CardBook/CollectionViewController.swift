//
//  CollectionViewController.swift
//  CardBook
//
//  Created by Hale on 2017/3/8.
//  Copyright © 2017年 Hale. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class CollectionViewCell: UICollectionViewCell {
    
    var transformView: UIView!
    
    var removeItem: (()->Void)!
    
    func config() {
        transformView.frame = CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width - 32, height: frame.height))
    }
    
    func commonInit() {
        transformView = UIView()
        transformView.backgroundColor = UIColor.white
        transformView.layer.cornerRadius = 2
        transformView.layer.shadowColor = UIColor.black.cgColor
        transformView.layer.shadowRadius = 5
        transformView.layer.shadowOpacity = 0.1
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panItem(_:)))
        transformView.isUserInteractionEnabled = true
        transformView.addGestureRecognizer(pan)
        transformView.layer.anchorPoint = CGPoint(x: 0.2, y: 0.9)
        addSubview(transformView)
    }
    
    func panItem(_ gesture: UIPanGestureRecognizer) {
        let delta = gesture.translation(in: self).x
        var percent = abs(delta) / (frame.width / 2)
        if percent > 1 { percent = 1 }
        let scale = 0.8 + 0.2 * (1 - percent)
        var rotateTransform: CGAffineTransform!
        if delta < 0 {
            // move to left
            transformView.layer.anchorPoint = CGPoint(x: 0.2, y: 0.9)
            rotateTransform = CGAffineTransform(rotationAngle: -CGFloat(M_PI / 6) * percent)
        } else {
            transformView.layer.anchorPoint = CGPoint(x: 0.2, y: 0.9)
            rotateTransform = CGAffineTransform(rotationAngle: -CGFloat(M_PI / 6) * percent)
        }
        let scaleTransform = CGAffineTransform(scaleX: scale, y: scale)
        let transforms = scaleTransform.concatenating(rotateTransform)
        transformView.transform = transforms
        alpha = 1 - percent
        if gesture.state == .ended {
            if percent > 0.5 {
                transformView.removeFromSuperview()
                removeItem()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
}

class CollectionViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var dataArray = [9,8,7,6,5,4,3,2,1,0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cardLayout = CollectionViewLayout()
        cardLayout.visibleCount = 3
        cardLayout.margin = 15
        cardLayout.itemSize = CGSize(width: UIScreen.main.bounds.width - 32, height: UIScreen.main.bounds.height - 200 - CGFloat(cardLayout.visibleCount - 1) * cardLayout.margin)
        collectionView!.setCollectionViewLayout(cardLayout, animated: true)
        collectionView!.contentInset = UIEdgeInsets(top: cardLayout.margin * 3, left: 0, bottom: 0, right: 0)
        collectionView!.scrollToItem(at: IndexPath(row: collectionView!.numberOfItems(inSection: 0) - 1, section: 0), at: .bottom, animated: false)
    }
}


// MARK: - UICollectionViewDataSource & UICollectionViewDelegate
extension CollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
        cell.config()
        cell.removeItem = {
            self.dataArray.remove(at: indexPath.row)
            collectionView.deleteItems(at: [indexPath])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Did select item at \(indexPath.row).")
    }
}
