//
//  DiffingRenderer.swift
//  HumbleDeclarative
//
//  Created by Neo on 2019/9/22.
//  Copyright © 2019 STH. All rights reserved.
//

import UIKit

protocol DiffingRenderer: UIView {
    func update(diffs: [Change<Int>], updatedNodes: [ViewNode])
}

extension UIStackView: DiffingRenderer {
    func update(diffs: [Change<Int>], updatedNodes: [ViewNode]) {
        for diff in diffs {
            switch diff {
            case .insert(let offset, _):
                let hostedView = updatedNodes[offset].viewType.init()
                hostedView.setup(state: updatedNodes[offset].state)
                insertArrangedSubview(hostedView, at: offset)
            case .remove(let offset, _):
                arrangedSubviews[offset].removeFromSuperview()
            case .substitude(let offset, _, _):
                if let hostedView = arrangedSubviews[offset] as? StateUpdatable {
                    hostedView.setup(state: updatedNodes[offset].state)
                } else {
                    assert(false, "View at index \(offset) is not StateUpdatable, the stackView might be modified outside?")
                }
            }
        }
    }
}
