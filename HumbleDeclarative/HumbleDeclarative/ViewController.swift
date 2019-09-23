//
//  ViewController.swift
//  HumbleDeclarative
//
//  Created by Neo on 2019/9/22.
//  Copyright © 2019 STH. All rights reserved.
//

import UIKit

class ViewController : UIViewController, ViewComponent {

    // MARK: The state

    // The usage here could be replace by property wrapper

    lazy var state1: StateStore<LabelState> = {
        return StateStore(updateHandler: renderCoordinator, value: .init(isHidden: false, text: "Label 1"))
    }()

    lazy var state2: StateStore<ButtonState> = {
        return StateStore(updateHandler: renderCoordinator, value: .init(isHidden: false, title: "Button"))
    }()

    lazy var state3: StateStore<LabelState> = {
        return StateStore(updateHandler: renderCoordinator, value: .init(isHidden: true, text: "Label 3"))
    }()

    // The usage here could be replace by function builder/opaque type in Swift 5.1

    func render() -> [ViewNode] {
        return [
            .label(state1),
            .label(state3),
            .button(state2),
        ]
    }

    // MARK: Ccore components

    // The view controller contains the hostView (for rendering the componenent) and the render coordinator (for calculating the diffing from render() and push change back)

    var hostView: DiffingRenderer = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        stackView.alignment = .leading
        return stackView
    }()

    lazy var renderCoordinator: RenderCycleCoordinator = {
        return RenderCycleCoordinator(viewComponent: self)
    }()

    // MARK: -
    // MARK: setup buttons and actions for demo

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        view.addSubview(hostView)
        NSLayoutConstraint.activate([
            hostView.topAnchor.constraint(equalTo: view.topAnchor),
            hostView.leftAnchor.constraint(equalTo: view.leftAnchor),
            hostView.rightAnchor.constraint(equalTo: view.rightAnchor)
            ])

        makeBtn(title: "Change value 1", action: #selector(changeValue1))
        makeBtn(title: "Change value 2", action: #selector(changeValue2))
        makeBtn(title: "Show hidden label", action: #selector(showHIddenLabel))

        renderCoordinator.start()
    }

    @objc func changeValue1() {
        state1.value.text = "Label 1 updated"
    }
    @objc func changeValue2() {
        state2.value.title = "Label 2 updated"
    }
    @objc func showHIddenLabel() {
        state3.value.isHidden = !state3.value.isHidden
    }

    // MARK: Helper
    private func makeBtn(title: String, action: Selector) {
        let btn = UIButton(type: .custom)
        btn.translatesAutoresizingMaskIntoConstraints = false
        if let lastBtn = view.subviews.compactMap({ $0 as? UIButton }).last {
            view.addSubview(btn)
            btn.topAnchor.constraint(equalTo: lastBtn.bottomAnchor, constant: 20).isActive = true
        } else {
            view.addSubview(btn)
            btn.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
        }
        btn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitle(title, for: .normal)
        btn.addTarget(self, action: action, for: .touchUpInside)
        btn.setTitleColor(.black, for: .normal)
    }

}

