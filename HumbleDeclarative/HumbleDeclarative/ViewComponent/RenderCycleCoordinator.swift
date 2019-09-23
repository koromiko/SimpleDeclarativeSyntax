//
//  RenderCycleCoordinator.swift
//  HumbleDeclarative
//
//  Created by Neo on 2019/9/22.
//  Copyright © 2019 STH. All rights reserved.
//

import UIKit
protocol ViewComponent: AnyObject {
    var hostView: DiffingRenderer { get }
    func render() -> [ViewNode]
}

protocol StateUpdateHandler: AnyObject {
    func stateDidUpdate()
}

class RenderCycleCoordinator: StateUpdateHandler {
    var diffingProvider: DiffingProvider = DefaultDiffingProvider()
    private weak var viewComponent: ViewComponent?

    private var oldNodeFootprint: [Int] = []
    init(viewComponent: ViewComponent) {
        self.viewComponent = viewComponent
    }

    func start() {
        stateDidUpdate()
    }

    func stateDidUpdate() {
        guard let viewComponent = viewComponent else {
            assert(false, "ViewComponent has to be provided")
        }
        let nodes = viewComponent.render()
        let newNodeFootprint = nodes.map { $0.hashValue }
        let diffs = diffingProvider.difference(oldCollection: oldNodeFootprint, newCollection: newNodeFootprint)
        viewComponent.hostView.update(diffs: diffs, updatedNodes: nodes)
        oldNodeFootprint = newNodeFootprint
    }
}
