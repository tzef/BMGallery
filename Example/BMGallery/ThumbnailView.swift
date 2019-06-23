//
//  ThumbnailView.swift
//  BMGallery_Example
//
//  Created by LEE ZHE YU on 2019/6/23.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

extension ThumbnailView {
    static func initWithType(_ data: ThumbnailData) -> ThumbnailView {
        if let view = Bundle.main.loadNibNamed("ThumbnailView", owner: nil, options: nil)?.first as? ThumbnailView {
            view.data = data
            return view
        }
        return ThumbnailView()
    }
}
class ThumbnailView: UIView {
    @IBOutlet weak var imageView: UIImageView!

    private var data: ThumbnailData? {
        didSet {
            imageView.image = data?.image
        }
    }

    override func awakeFromNib() {
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 5.0
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.lightGray.cgColor
    }
}
