//
//  ViewController.swift
//  JustListen
//
//  Created by Hoseung Kim on 2016. 7. 18..
//  Copyright © 2016년 Sebatyler. All rights reserved.
//

import UIKit
import YouTubePlayer

class ViewController: UIViewController {
    @IBOutlet weak var videoPlayer: YouTubePlayerView!
    @IBOutlet weak var playButton: UIButton!
    
    @IBAction func play(sender: UIButton) {
        self.videoPlayer.play()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.videoPlayer.loadVideoID("rUSddpvB4X0")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

