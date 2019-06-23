//
//  DetailViewController.swift
//  BMGallery_Example
//
//  Created by LEE ZHE YU on 2019/6/23.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import BMGallery
import AVFoundation

extension DetailViewController {
    static func initWithType(_ data: ThumbnailData) -> DetailViewController {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            vc.data = data
            return vc
        }
        return DetailViewController()
    }
}
class DetailViewController: UIViewController, BMGalleryTransitioningDestination {
    @IBOutlet weak var closeBtn: CloseButton!
    @IBOutlet weak var contentView: UIView!

    private var data: ThumbnailData?
    private lazy var playerLayer: AVPlayerLayer = {
        let layer = AVPlayerLayer(player: player)
        layer.videoGravity = .resizeAspectFill
        return layer
    }()
    private lazy var player: AVPlayer? = {
        guard let file = self.data?.fileName, let fileName = file.split(separator: ".").first, let fileExtention = file.split(separator: ".").last else {
            return nil
        }
        guard let path = Bundle.main.path(forResource: String(fileName), ofType: String(fileExtention)) else {
            return nil
        }
        return AVPlayer(url: URL(fileURLWithPath: path))
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.layer.addSublayer(playerLayer)
    }
    deinit {
        print("DetailViewController deinit")
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer.frame = contentView.bounds
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.33) {
            self.closeBtn.alpha = 1.0
        }
        player?.play()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        closeBtn.alpha = 0.0
    }
    
    @IBAction func closeAction(_ sender: Any) {
        guard let navigationController = self.navigationController else {
            return
        }
        self.sourceBMGallery?.transition.pop(from: navigationController)
    }
}
