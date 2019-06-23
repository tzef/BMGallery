//
//  BMGalleryPopAnimatedTransitioning.swift
//  BMGallery
//
//  Created by LEE ZHE YU on 2019/6/23.
//

import UIKit

class BMGalleryPopAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    weak var delegate: BMGalleryAnimatedTransitioningDataSource?
    var duration = TimeInterval(0.33)
    weak var fromView: UIView?
    weak var toView: UIView?
    convenience init(delegate: BMGalleryAnimatedTransitioningDataSource) {
        self.init()
        self.delegate = delegate
    }
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to) else {
                transitionContext.completeTransition(transitionContext.transitionWasCancelled)
                return
        }
        self.toView = toVC.view
        self.fromView = fromVC.view
        DispatchQueue.main.async {
            transitionContext.containerView.addSubview(toVC.view)
            if let animatedSource = self.delegate?.bmGalleryGetAnimatedSource(),
                let snapFrom = fromVC.view.snapshotView(afterScreenUpdates: true),
                let snapTo = animatedSource.snapshotView(afterScreenUpdates: true) {
                self.toView = animatedSource
                let snapToRatio = snapTo.bounds.height / snapTo.bounds.width
                let snapFromRatio = snapFrom.bounds.height / snapFrom.bounds.width
                let sourceFrame = transitionContext.containerView.convert(animatedSource.frame, from: animatedSource)
                var snapFromTargetFrame = sourceFrame
                snapTo.frame = fromVC.view.frame
                if snapFromRatio > snapToRatio {
                    let snapToWidth = fromVC.view.bounds.height / snapToRatio
                    snapTo.frame = CGRect(origin: CGPoint(x: (fromVC.view.bounds.width - snapToWidth) / 2, y: 0),
                                          size: CGSize(width: snapToWidth, height: fromVC.view.bounds.height))
                } else {
                    let snapToHeight = fromVC.view.bounds.width * snapToRatio
                    snapTo.frame = CGRect(origin: CGPoint(x: 0, y: (fromVC.view.bounds.height - snapToHeight) / 2),
                                          size: CGSize(width: fromVC.view.bounds.width, height: snapToHeight))
                }
                if snapToRatio > snapFromRatio {
                    let snapFromWidth = sourceFrame.height / snapFromRatio
                    snapFromTargetFrame = CGRect(origin: CGPoint(x: (sourceFrame.width - snapFromWidth) / 2, y: 0),
                                                 size: CGSize(width: snapFromWidth, height: sourceFrame.height))
                } else {
                    let snapFromHeight = sourceFrame.width * snapFromRatio
                    snapFromTargetFrame = CGRect(origin: CGPoint(x: 0, y: (sourceFrame.height - snapFromHeight) / 2),
                                                 size: CGSize(width: sourceFrame.width, height: snapFromHeight))
                }
                let maskView = UIView(frame: fromVC.view.frame)
                maskView.backgroundColor = UIColor.white
                maskView.clipsToBounds = true
                maskView.addSubview(snapTo)
                maskView.addSubview(snapFrom)
                snapTo.alpha = 0.0
                transitionContext.containerView.addSubview(maskView)
                UIView.animate(withDuration: self.duration, animations: {
                    maskView.frame = sourceFrame
                    snapFrom.frame = snapFromTargetFrame
                    snapFrom.alpha = 0.0
                    snapTo.frame = CGRect(origin: .zero, size: sourceFrame.size)
                    snapTo.alpha = 1.0
                }) { (_) in
                    maskView.removeFromSuperview()
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                }
            } else {
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
        if let from = self.fromView, let to = self.toView {
            delegate?.bmGalleryAnimatedStart(from: from, to: to)
        }
    }
    func animationEnded(_ transitionCompleted: Bool) {
        if let from = self.fromView, let to = self.toView {
            delegate?.bmGalleryAnimatedEnd(from: from, to: to)
        }
    }
}

