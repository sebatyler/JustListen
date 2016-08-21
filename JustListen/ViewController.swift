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


class ViewController: UIViewController, YTPlayerViewDelegate {
    @IBOutlet weak var playerView: YTPlayerView!
    var playlist: NSArray?
    var url: String?
    var playlistIdx = -1
    let playerVars: [String: AnyObject] = ["origin": "http://www.youtube.com", "playsinline": 1]
    let playlistUrl = "https://www.letmedoctor.com/playlist.json"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.getPlaylist()
        self.playerView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func getPlaylist() {
        Alamofire.request(.GET, self.playlistUrl).validate().responseJSON { response in
            switch response.result {
            case .Success(let JSON):
                self.playlist = JSON.objectForKey("playlist") as? NSArray
                self.url = JSON.objectForKey("url") as? String
                self.loadNext()
            case .Failure(let error):
                print(error)
            }
        }
    }
    
    private func loadNext() {
        var idx = playlistIdx
        idx += 1
        idx %= (playlist?.count)!
        let videoId = playlist?.objectAtIndex(idx).objectForKey("id") as? String
        self.playlistIdx = idx
        self.playerView.loadWithVideoId(videoId!, playerVars: self.playerVars)
        
    }
    
    func playerViewDidBecomeReady(playerView: YTPlayerView) {
        playerView.playVideo()
    }
    
    func playerView(playerView: YTPlayerView, didChangeToState state: YTPlayerState) {
        if (state == YTPlayerState.Ended) {
            self.loadNext()
        }
    }
}