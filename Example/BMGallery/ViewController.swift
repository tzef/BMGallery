//
//  ViewController.swift
//  BMGallery
//
//  Created by LEE ZHE YU on 06/23/2019.
//  Copyright (c) 2019 LEE ZHE YU. All rights reserved.
//

import UIKit
import BMGallery

struct ThumbnailData {
    var image: UIImage?
    var fileName: String?
}

class ViewController: UIViewController {
    @IBOutlet weak var bmoGallery: BMGallery!
    var datas = [
        ThumbnailData(image: UIImage(named: "sample1.png"), fileName: "sample1.mp4"),
        ThumbnailData(image: UIImage(named: "sample2.png"), fileName: "sample2.mp4"),
        ThumbnailData(image: UIImage(named: "sample3.png"), fileName: "sample3.mp4"),
        ThumbnailData(image: UIImage(named: "sample4.png"), fileName: "sample4.mp4"),
        ThumbnailData(image: UIImage(named: "sample5.png"), fileName: "sample5.mp4"),
        ThumbnailData(image: UIImage(named: "sample6.png"), fileName: "sample6.mp4")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        bmoGallery.delegate = self
        bmoGallery.dataSource = self
        bmoGallery.layoutType = .aspect(ratio: 30 / 23, itemCountOfLine: 3, margin: 8.0)
    }
}

extension ViewController: BMGalleryDelegate {
    func bmGalleryDelegateItemSelected(in galleryView: BMGallery, at: Int) {
        guard let navigationController = self.navigationController else {
            return
        }
        let vc = DetailViewController.initWithType(datas[at])
        galleryView.transition.push(vc, to: navigationController, fromItem: at)
    }

    func bmGalleryDelegateDidEndTransition(_ type: BMGalleryTransitioningType, from: UIView, to: UIView) {
        print("DidEnd Start Transition")
    }

    func bmGalleryDelegateWillStartTransition(_ type: BMGalleryTransitioningType, from: UIView, to: UIView) {
        print("Will Start Transition")
    }
}

extension ViewController: BMGalleryDataSource {
    func bmGalleryDataSourceNumberOfItems(in galleryView: BMGallery) -> Int {
        return 6
    }
    func bmGalleryDataSourceContentViewForItem(at: Int, contentView: UIView) {
        let subView = ThumbnailView.initWithType(datas[at])
        subView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(subView)
        let layoutViews = ["subView": subView]
        NSLayoutConstraint.activate(
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[subView]-0-|",
                                           metrics: nil, views: layoutViews) +
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[subView]-0-|",
                                               metrics: nil, views: layoutViews)
        )
    }
}
