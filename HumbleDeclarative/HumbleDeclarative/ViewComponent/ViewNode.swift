//
//  ViewNode.swift
//  HumbleDeclarative
//
//  Created by Neo on 2019/9/22.
//  Copyright © 2019 STH. All rights reserved.
//

import UIKit

// Due to the limitation of the type, There are limited way to handle the generic of the ViewNode. 

/// View node that is a enum representing a view, proivding class association to the view, and hash value for the state. E.g Label, Button, etc.
enum ViewNode: Hashable {
    case label(StateStore<LabelState>)
    case button(StateStore<ButtonState>)

    var viewType: StateUpdatable.Type {
        switch self {
        case .label:
            return UILabel.self
        case .button:
            return UILabel.self
        }
    }

    var state: ViewState {
        switch self {
        case .label(let store):
            return store.value
        case .button(let store):
            return store.value
        }
    }

    func hash(into hasher: inout Hasher) {
        switch self {
        case .label(let store):
            hasher.combine(store.value)
        case .button(let store):
            hasher.combine(store.value)
        }
    }

    static func == (lhs: ViewNode, rhs: ViewNode) -> Bool {
        switch (lhs, rhs) {
        case (.label(let storeLhs), .label(let storeRhs)):
            return storeLhs.value == storeRhs.value
        case (.button(let storeLhs), .button(let storeRhs)):
            return storeLhs.value == storeRhs.value
        default:
            return false
        }
    }
}
