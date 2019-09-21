//
//  UIView+Identifiable.swift
//  LazyNight
//
//  Created by Neo on 2019/9/9.
//  Copyright © 2019 STH. All rights reserved.
//

import UIKit

public protocol CellIdentifiable {
    static var uniqueCellIdentifier: String { get }
}

extension CellIdentifiable {
    public static var uniqueCellIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: CellIdentifiable {}
extension UICollectionViewCell: CellIdentifiable {}

public extension UITableView {
    func register<T: UITableViewCell>(cellType: T.Type) {
        register(cellType, forCellReuseIdentifier: cellType.uniqueCellIdentifier)
    }
}

public extension UICollectionView {
    func register<T: UICollectionViewCell>(cellType: T.Type) {
        register(cellType, forCellWithReuseIdentifier: cellType.uniqueCellIdentifier)
    }
}
