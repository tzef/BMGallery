//
//  CloseButton.swift
//  BMGallery_Example
//
//  Created by LEE ZHE YU on 2019/6/23.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

@IBDesignable
class CloseButton: UIButton {
    @IBInspectable var borderMargin: CGFloat = 3.0
    @IBInspectable var crossPadding: CGFloat = 6.0
    @IBInspectable var crossPathWidth: CGFloat = 3.0
    @IBInspectable var borderPathWidth: CGFloat = 1.5
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    func commonInit() {
        self.setTitle(nil, for: .normal)
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        UIColor.white.setStroke()
        if self.isHighlighted {
            UIColor.black.setFill()
        } else {
            UIColor.lightGray.setFill()
        }
        context.setLineCap(.round)
        context.setLineWidth(borderPathWidth)
        context.fillEllipse(in: rect.insetBy(dx: borderMargin, dy: borderMargin))
        context.setLineWidth(crossPathWidth)
        context.move(to: CGPoint(x: rect.minX + borderMargin + crossPadding, y: rect.minY + borderMargin + crossPadding))
        context.addLine(to: CGPoint(x: rect.maxX - borderMargin - crossPadding, y: rect.maxY - borderMargin - crossPadding))
        context.move(to: CGPoint(x: rect.maxX - borderMargin - crossPadding, y: rect.minY + borderMargin + crossPadding))
        context.addLine(to: CGPoint(x: rect.minX + borderMargin + crossPadding, y: rect.maxY - borderMargin - crossPadding))
        context.strokePath()
    }

    override var isHighlighted: Bool {
        didSet {
            self.setNeedsDisplay()
        }
    }
}
