//
//  BMGallery.swift
//  BMGallery
//
//  Created by LEE ZHE YU on 2019/6/23.
//

import UIKit

/// default setting is 3 item of a line for ratio 1:1
public enum BMGalleryLayout {
    case aspect(ratio: CGFloat, itemCountOfLine: Int, margin: CGFloat)
    case fixHeight(height: CGFloat, itemCountOfLine: Int, margin: CGFloat)
}

public protocol BMGalleryDelegate: class {
    func bmGalleryDelegateItemSelected(in galleryView: BMGallery, at: Int)
    func bmGalleryDelegateDidEndTransition(_ type: BMGalleryTransitioningType, from: UIView, to: UIView)
    func bmGalleryDelegateWillStartTransition(_ type: BMGalleryTransitioningType, from: UIView, to: UIView)
}

public protocol BMGalleryDataSource: class {
    func bmGalleryDataSourceContentViewForItem(at: Int, contentView: UIView)
    func bmGalleryDataSourceNumberOfItems(in galleryView: BMGallery) -> Int
}

@IBDesignable
public class BMGallery: UIView {
    private var inited = false
    private(set) lazy var collectionView: BMGalleryCollectionView = {
        let collectionView = BMGalleryCollectionView(layoutTyp: layoutType)
        collectionView.delegate = collectionAdapter
        collectionView.dataSource = collectionAdapter
        collectionView.register(BMGalleryCell.classForCoder(), forCellWithReuseIdentifier: BMGalleryCell.identifier)
        return collectionView
    }()
    private lazy var collectionAdapter: BMGalleryCollectionAdapter = {
        return BMGalleryCollectionAdapter(gallery: self)
    }()
    public weak var delegate: BMGalleryDelegate?
    public weak var dataSource: BMGalleryDataSource?
    public var animatedWhenChangeLayoutType = false
    public var layoutType = BMGalleryLayout.aspect(ratio: 1, itemCountOfLine: 3, margin: 8.0) {
        didSet {
            collectionAdapter.layoutType = layoutType
        }
    }
    public lazy var transition: BMGalleryTransitioningController = {
        return BMGalleryTransitioningController(sourceBMGallery: self)
    }()
    override public func didMoveToWindow() {
        super.didMoveToWindow()
        if self.window != nil && !inited {
            inited = true
            self.addSubview(collectionView)
            collectionView.backgroundColor = .clear
            self.subviews.forEach({ $0.translatesAutoresizingMaskIntoConstraints = false })
            let layoutViews = ["collectionView": collectionView]
            NSLayoutConstraint.activate(
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[collectionView]-0-|",
                                               metrics: nil, views: layoutViews) +
                    NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[collectionView]-0-|",
                                                   metrics: nil, views: layoutViews)
            )
        }
    }

    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        var first = true
        if self.dataSource != nil { return }
        let mainAttributed = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 24.0)
        ]
        let subAttributed = [
            NSAttributedString.Key.foregroundColor: UIColor.lightGray,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17.0)
        ]
        var totalHeight: CGFloat = 0.0
        let strs = ["BM Gallery View",
                    "Need to implement",
                    "BMGalleryDataSource"].map { (str) -> (String, CGSize) in
                        let size = str.bmGallery.size(attribute: first ? mainAttributed : subAttributed, size: .zero)
                        totalHeight += size.height + 8 * 3
                        first = false
                        return (str, size)
        }
        first = true
        var height: CGFloat = 0.0
        strs.forEach { (text, size) in
            let point = CGPoint(x: rect.midX - size.width / 2, y: rect.midY - totalHeight / 2 + height)
            (text as NSString).draw(at: point, withAttributes: first ? mainAttributed : subAttributed)
            height += size.height
            first = false
        }
    }

    // MARK: - Public
    func reload() {
        self.collectionView.reloadData()
    }

    // MARK: - Internal
    func getItemContentViewAt(_ at: Int) -> UIView? {
        return self.collectionView.cellForItem(at: IndexPath(row: at, section: 0))?.contentView
    }
}

public class BMGalleryCollectionView: UICollectionView {
    var layoutType = BMGalleryLayout.aspect(ratio: 1, itemCountOfLine: 3, margin: 8.0)
    convenience init(layoutTyp: BMGalleryLayout) {
        self.init(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        self.layoutType = layoutTyp
    }
    public override var bounds: CGRect {
        didSet {
            if oldValue.width != bounds.width {
                self.collectionViewLayout.invalidateLayout()
            }
        }
    }
}
