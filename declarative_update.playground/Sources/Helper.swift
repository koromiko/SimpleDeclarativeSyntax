import UIKit

public extension UILabel {
    static func createLabel() -> UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 45))
        label.textColor = .gray
        label.font = .systemFont(ofSize: 17)
        label.backgroundColor = UIColor.gray.withAlphaComponent(0.3)
        return label
    }
}

