//
//  StateStore.swift
//  HumbleDeclarative
//
//  Created by Neo on 2019/9/23.
//  Copyright © 2019 STH. All rights reserved.
//

import Foundation

/// A single state wrapper
class StateStore<T: Hashable> {
    var value: T {
        didSet {
            updateHandler?.stateDidUpdate()
        }
    }
    private weak var updateHandler: StateUpdateHandler?

    init(updateHandler: StateUpdateHandler, value: T) {
        self.updateHandler = updateHandler
        self.value = value
    }
}
