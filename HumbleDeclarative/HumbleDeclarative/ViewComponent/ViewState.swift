//
//  ViewState.swift
//  HumbleDeclarative
//
//  Created by Neo on 2019/9/22.
//  Copyright © 2019 STH. All rights reserved.
//

import UIKit

/// A state for a view
protocol ViewState {}

struct LabelState: ViewState, Hashable {
    var isHidden: Bool
    var text: String?
    func hash(into hasher: inout Hasher) {
        hasher.combine(text)
        hasher.combine(isHidden)
    }
}
struct ButtonState: ViewState, Hashable {
    var isHidden: Bool
    var title: String?
    var action: (() -> Void)?

    static func == (lhs: ButtonState, rhs: ButtonState) -> Bool {
        return lhs.isHidden && rhs.isHidden && lhs.title == rhs.title
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(isHidden)
    }
}
