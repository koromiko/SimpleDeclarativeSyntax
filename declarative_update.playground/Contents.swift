import UIKit
import PlaygroundSupport

protocol Renderer: AnyObject {
    func render()
}

class StateStore<T: Hashable> {
    var value: T {
        didSet {
            assert(renderer != nil)
            renderer?.render()
        }
    }

    private weak var renderer: Renderer?

    init(renderer: Renderer, value: T) {
        self.renderer = renderer
        self.value = value
    }
}

protocol State {}
struct LabelState: State, Hashable {
    var isHidden: Bool
    var text: String?
    func hash(into hasher: inout Hasher) {
        hasher.combine(text)
        hasher.combine(isHidden)
    }
}

protocol StateUpdatable: UIView {
    func setup(state: State)
}
// Type-erasured container for view-prepresentivie struct, like Label, Button, etc
enum ViewRepresentivie: Hashable {
    case label(StateStore<LabelState>)

    var viewType: StateUpdatable.Type {
        switch self {
        case .label:
            return UILabel.self
        }
    }

    var state: State {
        switch self {
        case .label(let store):
            return store.value
        }
    }

    func hash(into hasher: inout Hasher) {
        switch self {
        case .label(let store):
            hasher.combine(store.value)
        }
    }

    static func == (lhs: ViewRepresentivie, rhs: ViewRepresentivie) -> Bool {
        switch (lhs, rhs) {
        case (.label(let storeLhs), .label(let storeRhs)):
            return storeLhs.value == storeRhs.value
        }
    }
}

// Make UILabel to support configuration by State
extension UILabel: StateUpdatable {
    func setup(state: State) {
        guard let state = state as? LabelState else {
            assert(false, "The input state is type type(of: state), which is not matching the required LabelState")
            return
        }
        self.text = state.text
        self.isHidden = state.isHidden
    }
}

class StackHost: UIStackView {
    private var viewStore: [Int: StateUpdatable] = [:]
    private var current: [Int] = []

    func update(_ updated: [ViewRepresentivie]) {
        let updatedFootprint = updated.map({$0.hashValue})
        let diffs = updatedFootprint.difference(from: current)

        for diff in diffs {
            switch diff {
            case .insert(let offset, let element, _):
                if let hostedView = viewStore[element.hashValue] {
                    hostedView.setup(state: updated[offset].state)
                    insertArrangedSubview(hostedView, at: offset)
                } else {
                    let hostedView = updated[offset].viewType.init()
                    hostedView.setup(state: updated[offset].state)
                    viewStore[element.hashValue] = hostedView
                    insertArrangedSubview(hostedView, at: offset)
                }

            case .remove(_ , let element, _):
                if let view = viewStore[element.hashValue] {
                    view.removeFromSuperview()
                    viewStore.removeValue(forKey: element.hashValue)
                }
            }
        }
        current = updatedFootprint
    }
}

class MyViewController : UIViewController, Renderer {
    lazy var stackView: StackHost = {
        let stackView = StackHost()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        stackView.alignment = .leading
        return stackView
    }()

    lazy var state1: StateStore<LabelState> = {
        return StateStore(renderer: self, value: .init(isHidden: false, text: "Label 1"))
    }()

    lazy var state2: StateStore<LabelState> = {
        return StateStore(renderer: self, value: .init(isHidden: false, text: "Label 2"))
    }()

    lazy var state3: StateStore<LabelState> = {
        return StateStore(renderer: self, value: .init(isHidden: true, text: "Label 3"))
    }()

    func render() {
        stackView.update([
            .label(state1),
            .label(state3),
            .label(state2),
        ])
    }

    // Mark: setup buttons and actions for demo
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.leftAnchor.constraint(equalTo: view.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: view.rightAnchor)
            ])

        makeBtn(title: "Change value 1", action: #selector(changeValue1))
        makeBtn(title: "Change value 2", action: #selector(changeValue2))
        makeBtn(title: "Show hidden label", action: #selector(showHIddenLabel))
        render()
    }

    @objc func changeValue1() {
        state1.value.text = "Label 1 updated"
    }
    @objc func changeValue2() {
        state2.value.text = "Label 2 updated"
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
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
