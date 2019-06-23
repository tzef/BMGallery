//
//  BMGalleryCollectionAdapter.swift
//  BMGallery
//
//  Created by LEE ZHE YU on 2019/6/23.
//

import UIKit

class BMGalleryCollectionAdapter: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    public var layoutType = BMGalleryLayout.aspect(ratio: 1, itemCountOfLine: 3, margin: 8.0)

    weak var gallery: BMGallery?
    convenience init(gallery: BMGallery) {
        self.init()
        self.gallery = gallery
    }

    // MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let gallery = self.gallery else {
            return 0
        }
        return gallery.dataSource?.bmGalleryDataSourceNumberOfItems(in: gallery) ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BMGalleryCell.identifier, for: indexPath)
        if let galleryCell = cell as? BMGalleryCell {
            gallery?.dataSource?.bmGalleryDataSourceContentViewForItem(at: indexPath.row, contentView: galleryCell.contentView)
        }
        return cell
    }

    // MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let gallery = self.gallery else {
            return
        }
        gallery.delegate?.bmGalleryDelegateItemSelected(in: gallery, at: indexPath.row)
    }
}

extension BMGalleryCollectionAdapter: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: margin(), left: margin(), bottom: margin(), right: margin())
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return margin()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }

    private func margin() -> CGFloat {
        switch self.layoutType {
        case .aspect(_, _, let margin):
            return margin
        case .fixHeight(_, _, let margin):
            return margin
        }
    }
    private func cellSize() -> CGSize {
        guard let size = gallery?.bounds.size else {
            return .zero
        }
        var sizeWidth = size.width
        var sizeHeight = sizeWidth
        switch self.layoutType {
        case .aspect(let ratio, let itemCountOfLine, let margin):
            sizeWidth = floor((sizeWidth - (margin * CGFloat(itemCountOfLine + 1))) / CGFloat(itemCountOfLine))
            sizeHeight = sizeWidth * ratio
        case .fixHeight(let height, let itemCountOfLine, let margin):
            sizeWidth = floor((sizeWidth - (margin * CGFloat(itemCountOfLine + 1))) / CGFloat(itemCountOfLine))
            sizeHeight = height
        }
        return CGSize(width: sizeWidth, height: sizeHeight)
    }
}
