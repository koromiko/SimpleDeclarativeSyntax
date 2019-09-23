//
//  StateUpdatable.swift
//  HumbleDeclarative
//
//  Created by Neo on 2019/9/22.
//  Copyright © 2019 STH. All rights reserved.
//

import UIKit

/// Conform this protocol to support state configuration
protocol StateUpdatable: UIView {
    func setup(state: ViewState)
}

// Make UI component to support configuration by ViewState
extension UILabel: StateUpdatable {
    func setup(state: ViewState) {
        guard let unwrappedState = state as? LabelState else {
            assert(false, "The input state is type \(type(of: state)), which is not matching the required LabelState")
            return
        }
        self.text = unwrappedState.text
        self.isHidden = unwrappedState.isHidden
    }
}
extension UIButton: StateUpdatable {
    func setup(state: ViewState) {
        guard let unwrappedStae = state as? ButtonState else {
            assert(false, "The input state is type \(type(of: state)), which is not matching the required LabelState")
            return
        }
        self.setTitle(unwrappedStae.title, for: .normal)
        self.isHidden = unwrappedStae.isHidden
    }
}
