//
//  BMGalleryPushAnimatedTransitioning.swift
//  BMGallery
//
//  Created by LEE ZHE YU on 2019/6/23.
//

import UIKit

class BMGalleryPushAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    weak var delegate: BMGalleryAnimatedTransitioningDataSource?
    weak var fromView: UIView?
    weak var toView: UIView?
    var duration = TimeInterval(0.33)
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
            if let animatedSource = self.delegate?.bmGalleryGetAnimatedSource(),
                let snapFrom = animatedSource.snapshotView(afterScreenUpdates: true),
                let snapTo = toVC.view.snapshotView(afterScreenUpdates: true) {
                self.fromView = animatedSource
                let snapToRatio = snapTo.bounds.height / snapTo.bounds.width
                let snapFromRatio = snapFrom.bounds.height / snapFrom.bounds.width
                let sourceFrame = animatedSource.convert(animatedSource.frame, to: transitionContext.containerView)
                let targetFrame = transitionContext.finalFrame(for: toVC)
                var snapFromTargetFrame = targetFrame
                if snapFromRatio > snapToRatio {
                    let snapToWidth = snapFrom.bounds.height / snapToRatio
                    snapTo.frame = CGRect(origin: CGPoint(x: (snapFrom.bounds.width - snapToWidth) / 2, y: 0),
                                          size: CGSize(width: snapToWidth, height: snapFrom.bounds.height))
                } else {
                    let snapToHeight = snapFrom.bounds.width * snapToRatio
                    snapTo.frame = CGRect(origin: CGPoint(x: 0, y: (snapFrom.bounds.height - snapToHeight) / 2),
                                          size: CGSize(width: snapFrom.bounds.width, height: snapToHeight))
                }
                if snapToRatio > snapFromRatio {
                    let snapFromWidth = targetFrame.height / snapFromRatio
                    snapFromTargetFrame = CGRect(origin: CGPoint(x: (targetFrame.width - snapFromWidth) / 2, y: 0),
                                                 size: CGSize(width: snapFromWidth, height: targetFrame.height))
                } else {
                    let snapFromHeight = targetFrame.width * snapFromRatio
                    snapFromTargetFrame = CGRect(origin: CGPoint(x: 0, y: (targetFrame.height - snapFromHeight) / 2),
                                                 size: CGSize(width: targetFrame.width, height: snapFromHeight))
                }
                let tempView = UIView.init(frame: snapFrom.frame)
                tempView.backgroundColor = .red

                let maskView = UIView(frame: sourceFrame)
                maskView.backgroundColor = UIColor.white
                maskView.clipsToBounds = true
                maskView.addSubview(snapTo)
                maskView.addSubview(snapFrom)
                snapTo.alpha = 0.0
                transitionContext.containerView.addSubview(maskView)
                UIView.animate(withDuration: self.duration, animations: {
                    maskView.frame = targetFrame
                    snapFrom.frame = snapFromTargetFrame
                    snapFrom.alpha = 0.0
                    snapTo.frame = targetFrame
                    snapTo.alpha = 1.0
                }) { (_) in
                    maskView.removeFromSuperview()
                    transitionContext.containerView.addSubview(toVC.view)
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                }
            } else {
                transitionContext.containerView.addSubview(toVC.view)
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
