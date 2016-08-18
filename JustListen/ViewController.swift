//
//  ViewController.swift
//  JustListen
//
//  Created by Hoseung Kim on 2016. 7. 18..
//  Copyright © 2016년 Sebatyler. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

class ViewController: UIViewController {
    @IBOutlet weak var playerView: YTPlayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let playerVars: [String: AnyObject] = ["origin": "http://www.youtube.com", "playsinline": 1]
        self.playerView.loadWithVideoId("rUSddpvB4X0", playerVars: playerVars)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

