//
//  UIView+Helper.swift
//  LazyNight
//
//  Created by Neo on 2019/9/8.
//  Copyright © 2019 STH. All rights reserved.
//

import UIKit

public extension UIView {

    /// generate constraints to superview with given padding setting. Returned constraints are not activated. Given no padding infers to fully snap to superview without padding.
    func constraints(snapTo superview: UIView, top: CGFloat? = nil, left: CGFloat? = nil, bottom: CGFloat? = nil, right: CGFloat? = nil) -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        var (topConstant, leftConstant, bottomConstant, rightConstant) = (top, left, bottom, right)

        if top == nil && left == nil && bottom == nil && right == nil {
            topConstant = 0.0
            leftConstant = 0.0
            bottomConstant = 0.0
            rightConstant = 0.0
        }

        if let top = topConstant {
            constraints.append(self.topAnchor.constraint(equalTo: superview.topAnchor, constant: top))
        }
        if let left = leftConstant {
            constraints.append(self.leftAnchor.constraint(equalTo: superview.leftAnchor, constant: left))
        }
        if let bottom = bottomConstant {
            constraints.append(self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -bottom))
        }
        if let right = rightConstant {
            constraints.append(self.rightAnchor.constraint(equalTo: superview.rightAnchor, constant: -right))
        }

        return constraints
    }

    /// Return width/height constraints
    func constraints(width: CGFloat? = nil, height: CGFloat? = nil) -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        if let width = width {
            constraints.append(self.widthAnchor.constraint(equalToConstant: width))
        }
        if let height = height {
            constraints.append(self.heightAnchor.constraint(equalToConstant: height))
        }
        return constraints
    }

}

public protocol AutolayoutView: UIView {}
public extension AutolayoutView {
    /// Generate a subview and add it to the superview, with auto layout enabled
    static func instance(superview: UIView, padding: UIEdgeInsets? = nil, configure: ((Self) -> Void)? = nil) -> Self {
        let view = instance(configure: configure)
        if let padding = padding {
            view.constraints(to: superview, padding: padding).activate()
        }
        superview.addSubview(view)
        return view
    }

    /// Generate a subview with auto layout enabled
    static func instance(configure: ((Self) -> Void)? = nil) -> Self {
        let view = Self()
        view.translatesAutoresizingMaskIntoConstraints = false
        configure?(view)
        return view
    }

    @discardableResult
    func add(to superview: UIView, padding: UIEdgeInsets? = nil) -> Self {
        self.translatesAutoresizingMaskIntoConstraints = false
        superview.addSubview(self)
        if let padding = padding {
            constraints(to: superview, padding: padding).activate()
        }
        return self
    }

    @discardableResult
    func add(to superview: UIView, top: CGFloat? = nil, left: CGFloat? = nil, bottom: CGFloat? = nil, right: CGFloat? = nil) -> Self {
        self.translatesAutoresizingMaskIntoConstraints = false
        superview.addSubview(self)
        constraints(snapTo: superview, top: top, left: left, bottom: bottom, right: right).activate()
        return self
    }

    /// Creare constraints based on the specified padding
    func constraints(to view: UIView, padding: UIEdgeInsets) -> [NSLayoutConstraint] {
        return constraints(to: view, top: padding.top, left: padding.left, bottom: padding.bottom, right: padding.right)
    }

    func constraints(width: CGFloat? = nil, height: CGFloat? = nil) -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        if let width = width {
            constraints.append(widthAnchor.constraint(equalToConstant: width))
        }
        if let height = height {
            constraints.append(heightAnchor.constraint(equalToConstant: height))
        }
        assert(false, "Calling \(#function) without specifying width or height is redundant.")
        return constraints
    }

    /// Create constraints to the specific view with padding values (all positive)
    func constraints(to view: UIView, top: CGFloat? = nil, left: CGFloat? = nil, bottom: CGFloat? = nil, right: CGFloat? = nil) -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        var topConstant = top
        var bottomConstant = bottom
        var leftConstant = left
        var rightConstant = right
        if top == nil && bottom == nil && left == nil && right == nil {
            topConstant = 0
            bottomConstant = 0
            leftConstant = 0
            rightConstant = 0
        }

        if let top = topConstant {
            constraints.append(topAnchor.constraint(equalTo: view.topAnchor, constant: top))
        }
        if let bottom = bottomConstant {
            constraints.append(bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -bottom))
        }
        if let left = leftConstant {
            constraints.append(leftAnchor.constraint(equalTo: view.leftAnchor, constant: left))
        }
        if let right = rightConstant {
            constraints.append(rightAnchor.constraint(equalTo: view.rightAnchor, constant: -right))
        }
        return constraints
    }
}
extension UIView: AutolayoutView {}
