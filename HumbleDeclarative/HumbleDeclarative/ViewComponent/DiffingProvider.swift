//
//  DiffingProvider.swift
//  HumbleDeclarative
//
//  Created by Neo on 2019/9/22.
//  Copyright © 2019 STH. All rights reserved.
//

import UIKit

enum Change<Element> {
    case insert(offset: Int, element: Element)
    case remove(offset: Int, element: Element)
    case substitude(offset: Int, oldElement: Element, newElement: Element)
}

/// Provide the edit distance algorithm
protocol DiffingProvider {
    /// Edit distance of given two collections
    func difference<T: Hashable>(oldCollection: [T], newCollection: [T]) -> [Change<T>]
}

/// Swift diffing provider
struct DefaultDiffingProvider: DiffingProvider {
    func difference<T: Hashable>(oldCollection: [T], newCollection: [T]) -> [Change<T>] {
        let diffs = newCollection.difference(from: oldCollection).map({ $0 })

        var skip = false
        return diffs.enumerated().compactMap {
            if skip {
                skip = false
                return nil
            }

            // Replacing case, look ahead
            if $0+1 < diffs.count {
                // insert after remove, at the same index
                if case .insert(let insertIndex, let newElement, _) = diffs[$0+1], case .remove(let removeIndex, let oldElement, _) = $1, insertIndex == removeIndex {
                    skip = true
                    return .substitude(offset: insertIndex, oldElement: oldElement, newElement: newElement)
                }
            }

            switch $1 {
            case .insert(let offset, let element, _):
                return .insert(offset: offset, element: element)
            case .remove(let offset , let element, _):
                return .remove(offset: offset, element: element)
            }
        }
    }
}
