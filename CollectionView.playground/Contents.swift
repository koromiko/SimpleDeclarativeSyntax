//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

struct Block: Equatable {
    let id: Int
    let title: String
    let price: Int
    let color: UIColor
    var selected: Bool = false

    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id && lhs.selected == rhs.selected
    }
}

class BlockCollectionViewCell: UICollectionViewCell {
    lazy var titleLabel: UILabel = {
        let label = UILabel.instance(superview: contentView)
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()

    lazy var subTitleLabel: UILabel = {
        let label = UILabel.instance(superview: contentView)
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initLayout()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initLayout()
    }

    func initLayout() {
        titleLabel.constraints(to: contentView, top: 5, left: 5, right: 5).activate()
        subTitleLabel.constraints(to: contentView, left: 5, bottom: 5, right: 5).activate()
        [subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10)].activate()
    }

    func setup(block: Block) {
        titleLabel.text = block.title
        subTitleLabel.text = "$\(block.price)"

        if block.selected {
            contentView.backgroundColor = .orange
        } else {
            contentView.backgroundColor = block.color
        }
    }

}

class HomeViewController: UIViewController {

    lazy var stackView: UIStackView = {
        let stackView = UIStackView().add(to: view)
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return stackView
    }()

    lazy var shuffleBtn: UIButton = {
        let btn = UIButton().add(to: view)
        btn.setTitle("Shuffle", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        btn.setTitleColor(.white, for: .normal)
        btn.addTarget(self, action: #selector(shulffle), for: .touchUpInside)
        btn.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return btn
    }()

    @objc func insertBlock() {
        items.insert(Block(id: items.count, title: "New", price: 300, color: .purple), at: Int.random(in: 0...100))
    }

    lazy var insertItemBtn: UIButton = {
        let btn = UIButton().add(to: view)
        btn.setTitle("Insert", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        btn.setTitleColor(.white, for: .normal)
        btn.addTarget(self, action: #selector(insertBlock), for: .touchUpInside)
        btn.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return btn
    }()

    lazy var resetBtn: UIButton = {
        let btn = UIButton().add(to: view)
        btn.setTitle("Reset", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        btn.setTitleColor(.white, for: .normal)
        btn.addTarget(self, action: #selector(reset), for: .touchUpInside)
        return btn
    }()

    lazy var priceLabel: UILabel = {
        let label = UILabel.instance()
        label.textColor = .lightGray
        label.font = UIFont.boldSystemFont(ofSize: 44)
        label.text = "$0"
        stackView.addArrangedSubview(label)
        return label
    }()

    lazy var messageLabel: UILabel = {
        var label = UILabel.instance()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .cyan
        stackView.addArrangedSubview(label)
        return label
    }()

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 3
        layout.itemSize = CGSize(width: 50, height: 50)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).add(to: view)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupLayout()
        setupCollectionView()
        getData()
    }

    func getData() {
        let blocks: [Block] = (0...255).map {
            return Block(id: $0, title: "\($0)", price: Int.random(in: 100...900), color: UIColor(red: CGFloat($0)/255.0, green: CGFloat($0)/255.0, blue: CGFloat($0)/255.0, alpha: 1.0))
        }
        self.items = blocks
    }

    func setupCollectionView() {
        collectionView.register(BlockCollectionViewCell.self, forCellWithReuseIdentifier: BlockCollectionViewCell.uniqueCellIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    func setupLayout() {
        collectionView.constraints(snapTo: view, left: 0, bottom: 0, right: 0).activate()
        shuffleBtn.constraints(snapTo: view, right: 15).activate()
        [collectionView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 15),
         shuffleBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
         insertItemBtn.rightAnchor.constraint(equalTo: shuffleBtn.leftAnchor, constant: -8),
         insertItemBtn.centerYAnchor.constraint(equalTo: shuffleBtn.centerYAnchor),
         resetBtn.rightAnchor.constraint(equalTo: shuffleBtn.rightAnchor),
         resetBtn.topAnchor.constraint(equalTo: shuffleBtn.bottomAnchor, constant: 8),
         resetBtn.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -8).withPriority(.defaultLow),
         stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
         stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
         stackView.rightAnchor.constraint(equalTo: insertItemBtn.leftAnchor, constant: -10)
            ].activate()
    }


    var items: [Block] = [] {
        didSet {
            DispatchQueue.global().async {
                let diffs = self.items.difference(from: oldValue)

                var insert: [IndexPath] = []
                var remove: [IndexPath] = []
                for change in diffs {
                    switch change {
                    case .insert(let offset, _, _):
                        insert.append(IndexPath(item: offset, section: 0))
                    case .remove(let offset, _, _):
                        remove.append(IndexPath(item: offset, section: 0))
                    }
                }
                DispatchQueue.main.async {
                    self.collectionView.performBatchUpdates({
                        self.collectionView.insertItems(at: insert)
                        self.collectionView.deleteItems(at: remove)
                    }, completion: nil)
                }
            }
        }
    }

    @objc func reset() {
        var updates = items
        for (i, u) in items.enumerated() {
            var update = u
            update.selected = false
            updates[i] = update
        }
        items = updates

        priceLabel.text = "$0"
        messageLabel.text = nil
    }

    @objc func shulffle() {
        items = items[0...104].shuffled() + items[105..<items.count]

    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BlockCollectionViewCell.uniqueCellIdentifier, for: indexPath) as? BlockCollectionViewCell {
            let block = items[indexPath.row]
            cell.setup(block: block)
            return cell
        }

        assert(false, "Unhandled case at indexPath \(indexPath)")
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        items[indexPath.row].selected = !items[indexPath.row].selected

        let totalPrice = items.filter { $0.selected }.map { $0.price }.reduce(0, +)

        priceLabel.text = "$\(totalPrice)"
        if totalPrice > 3000 {
            messageLabel.text = "Too much!"
        } else if totalPrice > 2000 {
            messageLabel.text = "Sale price eligible!!"
        } else if totalPrice > 1000 {
            messageLabel.text = "Add \(2000 - totalPrice) more!"
        }  else {
            messageLabel.text = nil
        }


        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }

    }
}

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = HomeViewController()
