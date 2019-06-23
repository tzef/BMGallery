//
//  BMGalleryTransitioningController.swift
//  BMGallery
//
//  Created by LEE ZHE YU on 2019/6/23.
//

import UIKit

private struct BMGalleryAssociatedKeys {
    static var SourceGallery = "bm_gallery_source_gallery"
}
extension BMGalleryTransitioningDestination {
    public var sourceBMGallery: BMGallery? {
        return self.filePrivateSourceBMGallery
    }
}
extension UIViewController {
    fileprivate var filePrivateSourceBMGallery: BMGallery? {
        get {
            return objc_getAssociatedObject(self, &BMGalleryAssociatedKeys.SourceGallery) as? BMGallery
        }
        set {
            objc_setAssociatedObject(self, &BMGalleryAssociatedKeys.SourceGallery, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
}

protocol BMGalleryAnimatedTransitioningDataSource: class {
    func bmGalleryAnimatedStart(from: UIView, to: UIView)
    func bmGalleryAnimatedEnd(from: UIView, to: UIView)
    func bmGalleryGetAnimatedSource() -> UIView?
}

public enum BMGalleryTransitioningType {
    case none
    case push
    case pop
    case present
    case dismiss
}

public class BMGalleryTransitioningController: NSObject, BMGalleryAnimatedTransitioningDataSource {
    weak var proxyDelegate: UINavigationControllerDelegate?
    weak var sourceBMGallery: BMGallery?
    var transitioningType = BMGalleryTransitioningType.none
    var fromItem: Int?

    convenience init(sourceBMGallery: BMGallery) {
        self.init()
        self.sourceBMGallery = sourceBMGallery
    }

    // MARK: - BMGalleryAnimatedTransitioningDataSource
    func bmGalleryGetAnimatedSource() -> UIView? {
        if let at = fromItem {
            return self.sourceBMGallery?.getItemContentViewAt(at)
        }
        return nil
    }
    func bmGalleryAnimatedEnd(from: UIView, to: UIView) {
        self.sourceBMGallery?.delegate?.bmGalleryDelegateDidEndTransition(transitioningType, from: from, to: to)
    }
    func bmGalleryAnimatedStart(from: UIView, to: UIView) {
        self.sourceBMGallery?.delegate?.bmGalleryDelegateWillStartTransition(transitioningType, from: from, to: to)
    }
    
    // MARK: - Public
    public func push(_ vc: UIViewController, to navigationController: UINavigationController, fromItem: Int) {
        self.fromItem = fromItem
        transitioningType = .push
        proxyDelegate = navigationController.delegate
        vc.filePrivateSourceBMGallery = sourceBMGallery
        navigationController.delegate = self
        navigationController.pushViewController(vc, animated: true)
    }
    public func pop(from navigationController: UINavigationController, toItem: Int? = nil) {
        if let item = toItem {
            fromItem = item
        }
        transitioningType = .pop
        navigationController.popViewController(animated: true)
        navigationController.delegate = proxyDelegate
    }

    override public func forwardingTarget(for aSelector: Selector!) -> Any? {
        if super.responds(to: aSelector) {
            return self
        } else if let delegate = self.proxyDelegate, delegate.responds(to: aSelector) {
            return delegate
        } else {
            return super.forwardingTarget(for: aSelector)
        }
    }
    override public func responds(to aSelector: Selector!) -> Bool {
        if super.responds(to: aSelector) {
            return true
        } else if let delegate = self.proxyDelegate {
            return delegate.responds(to: aSelector)
        } else {
            return super.responds(to: aSelector)
        }
    }
}

extension BMGalleryTransitioningController: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push:
            return BMGalleryPushAnimatedTransitioning(delegate: self)
        case .pop:
            return BMGalleryPopAnimatedTransitioning(delegate: self)
        default:
            return nil
        }
    }
}

extension BMGalleryTransitioningController: UIViewControllerTransitioningDelegate {
}
