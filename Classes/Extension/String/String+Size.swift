//
//  String+Size.swift
//  BMGallery
//
//  Created by LEE ZHE YU on 2019/6/23.
//

import UIKit

protocol BMGalleryStringType {
    var bmGalleryStringValue: String { get }
}
extension String: BMGalleryStringType {
    var bmGalleryStringValue: String {
        return String(self)
    }
}

public struct StringBMGalleryProxy<Type> {
    public var base: Type
    public init(_ base: Type) {
        self.base = base
    }
}
public protocol StringBMGalleryCompatible {
    var bmGallery: StringBMGalleryProxy<String> { get }
}

extension String: StringBMGalleryCompatible {
    public var bmGallery: StringBMGalleryProxy<String> {
        return StringBMGalleryProxy(self)
    }
}

extension StringBMGalleryProxy where Type: BMGalleryStringType {
    func size(attribute: [NSAttributedString.Key: Any], size: CGSize) -> CGSize {
        let attributedText = NSAttributedString(string: base.bmGalleryStringValue, attributes: attribute)
        return attributedText.boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil).size
    }
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.base.bmGalleryStringValue.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return ceil(boundingBox.height)
    }
    func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.base.bmGalleryStringValue.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return ceil(boundingBox.width)
    }
}
