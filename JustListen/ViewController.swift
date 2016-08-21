//
//  ViewController.swift
//  JustListen
//
//  Created by Hoseung Kim on 2016. 7. 18..
//  Copyright © 2016년 Sebatyler. All rights reserved.
//

import UIKit
import youtube_ios_player_helper
import Alamofire


class ViewController: UIViewController {
    @IBOutlet weak var playerView: YTPlayerView!
    var playlist: NSArray?
    var url: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        Alamofire.request(.GET, "https://www.letmedoctor.com/playlist.json").validate().responseJSON { response in
            switch response.result {
            case .Success(let JSON):
                self.playlist = JSON.objectForKey("playlist") as? NSArray
                self.url = JSON.objectForKey("url") as? String
                let videoId = self.playlist?.objectAtIndex(0).objectForKey("id") as? String
                let playerVars: [String: AnyObject] = ["origin": "http://www.youtube.com", "playsinline": 1]
                self.playerView.loadWithVideoId(videoId!, playerVars: playerVars)
            case .Failure(let error):
                print(error)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

