//
//  NSConstraint+Helper.swift
//  LazyNight
//
//  Created by Neo on 2019/9/8.
//  Copyright © 2019 STH. All rights reserved.
//

import UIKit

public extension Array where Element: NSLayoutConstraint {
    func activate() {
        for e in self {
            e.isActive = true
        }
    }
}

public extension NSLayoutConstraint {
    func withPriority(_ priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
}
