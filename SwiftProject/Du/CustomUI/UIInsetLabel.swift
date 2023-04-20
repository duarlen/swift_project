
import UIKit

public class UIInsetLabel: UILabel {
    
    public var contentInset: UIEdgeInsets = .zero {
        didSet {
            layoutSubviews()
        }
    }

    override public func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        return super.textRect(forBounds: bounds.inset(by: contentInset), limitedToNumberOfLines: numberOfLines)
    }

    override public func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: contentInset))
    }

    override public var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        let width = size.width + contentInset.left + contentInset.right
        let height = size.height + contentInset.top + contentInset.bottom
        return CGSize(width: width, height: height)
    }
}
