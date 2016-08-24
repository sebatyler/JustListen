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
import AVFoundation

extension Array {
    
    var shuffled: [Element] {
    
        var shuffledArray: [Element] = self
        
        for i in 0 ..< count {
            let remainingCount = count - i
            //figre out error below
            
              let exchangeIndex = i + Int(arc4random_uniform(UInt32(remainingCount)))
        
            if i != exchangeIndex {
                swap(&shuffledArray[i], &shuffledArray[exchangeIndex])
            }
        }
        
        return shuffledArray
    }
}


class ViewController: UIViewController, YTPlayerViewDelegate {
    @IBOutlet weak var playerView: YTPlayerView!
    @IBOutlet weak var playerControl: UISegmentedControl!
    @IBOutlet weak var repeatSwitch: UISwitch!
    
    var playlist: [AnyObject]?
    var url: String?
    var playlistIdx: Int? = -1
    var repeatSong = false
    let playerVars: [String: AnyObject] = ["origin": "http://www.youtube.com", "playsinline": 1]
    let playlistUrl = "https://www.letmedoctor.com/playlist.json"

    @IBAction func changeRepeatSwitch(sender: UISwitch) {
        self.repeatSong = sender.on
    }
    
    @IBAction func changePlayerControl(sender: UISegmentedControl) {
        title = sender.titleForSegmentAtIndex(sender.selectedSegmentIndex)
        
        guard let title = title else {
            return
        }
        
        switch title {
        case "Previous":
            self.loadSong(false)
        case "Pause/Play":
            if (self.playerView.playerState() == YTPlayerState.Playing) {
                self.playerView.pauseVideo()
            }
            else {
                self.playerView.playVideo()
            }
        case "Stop":
            self.playerView.stopVideo()
        case "Next":
            self.loadSong()
        default:
            return
        }
        sender.selectedSegmentIndex = -1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.getPlaylist()
        self.playerView.delegate = self
        self.enableBackgroundPlay()
    }
    
    private func getPlaylist() {
        Alamofire.request(.GET, self.playlistUrl).validate().responseJSON { response in
            switch response.result {
            case .Success(let JSON):
                
                guard let playlist = JSON["playlist"] as? [AnyObject] else {
                    return
                }
                
                self.playlist = playlist.shuffled
                self.url = JSON.objectForKey("url") as? String
                self.loadSong()
            case .Failure(let error):
                print(error)
            }
        }
    }
    
    private func loadSong(next: Bool = true) {
        if var idx = playlistIdx {
            idx += next ? 1 : -1
            if (idx < 0) {
                idx = 0
            }
            idx %= (playlist?.count)!
            
            if let videoId = self.playlist?[idx]["id"] as? String {
                self.playlistIdx = idx
                self.playerView.loadWithVideoId(videoId, playerVars: self.playerVars)
            }
        }
    }
    
    func playerViewDidBecomeReady(playerView: YTPlayerView) {
        playerView.playVideo()
    }
    
    func playerView(playerView: YTPlayerView, didChangeToState state: YTPlayerState) {
        if (state == YTPlayerState.Ended) {
            if (self.repeatSong) {
                self.playerView.playVideo()
            }
            else {
                self.loadSong()
            }
        }
    }
    
    private func enableBackgroundPlay() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            do {
                try AVAudioSession.sharedInstance().setActive(true)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}