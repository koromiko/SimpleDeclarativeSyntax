import Foundation
import UIKit
struct ImageViewDownloadAssociatedObject {
    static var key: String = "ImageViewDownloadAssociatedObject.key"
}

struct ImageCache {
    static var cacheTable: [String: UIImage] = [:]
}
public extension UIImageView {
    var imageUrlIdentifier: String? {
        get { return objc_getAssociatedObject(self, &ImageViewDownloadAssociatedObject.key) as? String }
        set { objc_setAssociatedObject(self, &ImageViewDownloadAssociatedObject.key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    func setupImage(url: String) {
        if let image = ImageCache.cacheTable[url] {
            self.image = image
        } else {
            self.image = nil
            DispatchQueue.global().async {
                self.imageUrlIdentifier = url
                if let data = try? Data(contentsOf: URL(string: url)!) {
                    DispatchQueue.main.async {
                        if url == self.imageUrlIdentifier {
                            if let image = UIImage(data: data) {
                                self.image = image
                                ImageCache.cacheTable[url] = image
                            } else {
                                self.image = nil
                            }
                        }
                    }
                }
            }
        }
    }
}
