//
//  ViewController.swift
//  CustomLoginDemo
//
//  Created by Christopher Ching on 2019-07-22.
//  Copyright © 2019 Christopher Ching. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController {

    var videoPlayer:AVPlayer?
    
    var videoPlayerLayer:AVPlayerLayer?
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setUpElements()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//
//        // Set up video in the background
//        setUpVideo()
//    }
//
    func setUpElements() {
        
        if let signUpBtn = signUpButton {
            Utilities.styleFilledButton(signUpBtn)
        }
        
        if let logInBtn = loginButton {
            Utilities.styleHollowButton(logInBtn)
        }
    }
    
//    func setUpVideo() {
//
//        // random video when logging in
//        let numberOfVideos: UInt32 = 1
//        let random = arc4random_uniform(numberOfVideos)
//        let videoName = "video_\(random)"
//
//        // Get the path to the resource in the bundle
//        let bundlePath = Bundle.main.path(forResource: "video_1", ofType: "mp4")
//
//        guard bundlePath != nil else {
//            return
//        }
//
//        // Create a URL from it
//        let url = URL(fileURLWithPath: bundlePath!)
//
//        // Create the video player item
//        let item = AVPlayerItem(url: url)
//
//        // Create the player
//        videoPlayer = AVPlayer(playerItem: item)
//
//        // Create the layer
//        videoPlayerLayer = AVPlayerLayer(player: videoPlayer!)
//
//        // Adjust the size and frame
//        videoPlayerLayer?.frame = CGRect(x: -self.view.frame.size.width*1, y: 0, width: self.view.frame.size.width*4, height: self.view.frame.size.height)
//
//        view.layer.insertSublayer(videoPlayerLayer!, at: 0)
//
//        // Add it to the view and play it
//        videoPlayer?.playImmediately(atRate: 0.5)
//    }


}

