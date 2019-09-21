//
//  UICollectionView+Helper.swift
//  LazyNight
//
//  Created by Neo on 2019/9/9.
//  Copyright © 2019 STH. All rights reserved.
//

import UIKit

// MARK: CollectionView Autolayout
struct CollectionViewCellLayoutAssociateKey {
    static var widthKey: String = "CollectionViewCellLayoutAssociateKey.width"
}
public extension UICollectionViewCell {
    private var widthConstraint: NSLayoutConstraint? {
        get {
            return objc_getAssociatedObject(self, &CollectionViewCellLayoutAssociateKey.widthKey) as? NSLayoutConstraint
        }
        set {
            objc_setAssociatedObject(self, &CollectionViewCellLayoutAssociateKey.widthKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    func setupWidthConstraint(constant: CGFloat) {
        if let widthConstraint = widthConstraint {
            widthConstraint.constant = constant
        } else {
            self.widthConstraint = contentView.widthAnchor.constraint(equalToConstant: constant)
            self.widthConstraint?.isActive = true
        }
    }
}
