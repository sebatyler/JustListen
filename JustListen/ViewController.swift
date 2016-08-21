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

func shuffle(array: NSArray) -> NSArray {
    let newArray : NSMutableArray = NSMutableArray(array: array)
    let count : NSInteger = newArray.count

    for i in 0 ..< count {
        let remainingCount = count - i
        //figre out error below
        let exchangeIndex = i + Int(arc4random_uniform(UInt32(remainingCount)))
        newArray.exchangeObjectAtIndex(i, withObjectAtIndex: exchangeIndex)
    }
    return NSArray(array: newArray)
}

class ViewController: UIViewController, YTPlayerViewDelegate {
    @IBOutlet weak var playerView: YTPlayerView!
    @IBOutlet weak var playerControl: UISegmentedControl!
    @IBOutlet weak var repeatSwitch: UISwitch!
    
    var playlist: NSArray?
    var url: String?
    var playlistIdx = -1
    var repeatSong = false
    let playerVars: [String: AnyObject] = ["origin": "http://www.youtube.com", "playsinline": 1]
    let playlistUrl = "https://www.letmedoctor.com/playlist.json"

    @IBAction func changeRepeatSwitch(sender: UISwitch) {
        self.repeatSong = sender.on
    }
    
    @IBAction func changePlayerControl(sender: UISegmentedControl) {
        title = sender.titleForSegmentAtIndex(sender.selectedSegmentIndex)
        
        switch title! {
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func getPlaylist() {
        Alamofire.request(.GET, self.playlistUrl).validate().responseJSON { response in
            switch response.result {
            case .Success(let JSON):
                self.playlist = shuffle((JSON.objectForKey("playlist") as? NSArray)!)
                self.url = JSON.objectForKey("url") as? String
                self.loadSong()
            case .Failure(let error):
                print(error)
            }
        }
    }
    
    private func loadSong(next: Bool = true) {
        var idx = playlistIdx
        idx += next ? 1 : -1
        if (idx < 0) {
            idx = 0
        }
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