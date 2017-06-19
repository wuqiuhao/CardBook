//
//  CollectionViewController.swift
//  CardBook
//
//  Created by Hale on 2017/3/8.
//  Copyright © 2017年 Hale. All rights reserved.
//

import UIKit

extension UIView {
    var viewController: UIViewController? {
        let next = superview
        while next != nil {
            if let nextResponder = next?.next {
                if let vc = nextResponder as? UIViewController {
                    return vc
                }
            }
        }
        return nil
    }
}

private let reuseIdentifier = "Cell"

class CollectionViewCell: UICollectionViewCell {
    
    var transformView: UIView!
    
    var removeItem: (()->Void)!
    
    var pan: UIPanGestureRecognizer!
    
    func config() {
        transformView.alpha = 1
        transformView.frame = CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width - 32, height: frame.height))
    }
    
    func commonInit() {
        transformView = UIView()
        transformView.backgroundColor = UIColor.white
        transformView.layer.cornerRadius = 2
        transformView.layer.shadowColor = UIColor.black.cgColor
        transformView.layer.shadowRadius = 5
        transformView.layer.shadowOpacity = 0.1
        pan = UIPanGestureRecognizer(target: self, action: #selector(panItem(_:)))
        pan.delegate = self
        transformView.isUserInteractionEnabled = true
        transformView.addGestureRecognizer(pan)
        addSubview(transformView)
    }
    
    func panItem(_ gesture: UILongPressGestureRecognizer) {
        let delta = pan.translation(in: self).x
        var percent = abs(delta) / (frame.width / 2)
        if percent > 1 { percent = 1 }
        let scale = 0.6 + 0.4 * (1 - percent)
        var rotateTransform: CGAffineTransform!
        if delta < 0 {
            // move to left
            rotateTransform = CGAffineTransform(rotationAngle: -.pi / 12 * percent)
        } else {
            rotateTransform = CGAffineTransform(rotationAngle: .pi / 12 * percent)
        }
        let scaleTransform = CGAffineTransform(scaleX: scale, y: scale)
        let moveTransform = CGAffineTransform(translationX: delta, y: 0)
        let transforms = scaleTransform.concatenating(rotateTransform).concatenating(moveTransform)
        transformView.transform = transforms
        transformView.alpha = 1 - percent
        if gesture.state == .ended {
            if percent > 0.5 {
                removeItem()
                transformView.alpha = 0
                transformView.transform = CGAffineTransform.identity
            } else {
                UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                    self.transformView.transform = CGAffineTransform.identity
                    self.transformView.alpha = 1
                })
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

extension CollectionViewCell: UIGestureRecognizerDelegate {
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == pan {
            let transition = pan.translation(in: self)
            if abs(transition.x) > abs(transition.y) {
                return true
            }
        }
        return false
    }
}

class CollectionViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var dataArray = [9,8,7,6,5,4,3,2,1,0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cardLayout = collectionView!.collectionViewLayout as! CollectionViewLayout
        cardLayout.itemSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 1.4 * (UIScreen.main.bounds.width - 32))
//        cardLayout.config()
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
            print("Did remove item \(indexPath.row).")
            collectionView.deleteItems(at: [indexPath])
            collectionView.reloadSections([indexPath.section])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Did select item at \(indexPath.row).")
    }
}
