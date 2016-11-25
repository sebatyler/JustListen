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
import GoogleMobileAds

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
    @IBOutlet weak var bannerView: GADBannerView!
    
    var playlist: [AnyObject]?
    var url: String?
    var playlistIdx: Int? = -1
    var repeatSong = false
    let playerVars: [String: AnyObject] = ["origin": "http://www.youtube.com" as AnyObject, "playsinline": 1 as AnyObject]
    let playlistUrl = "https://www.letmedoctor.com/playlist.json"

    @IBAction func changeRepeatSwitch(_ sender: UISwitch) {
        self.repeatSong = sender.isOn
    }
    
    @IBAction func changePlayerControl(_ sender: UISegmentedControl) {
        title = sender.titleForSegment(at: sender.selectedSegmentIndex)
        
        guard let title = title else {
            return
        }
        
        switch title {
        case "Previous":
            self.loadSong(false)
        case "Pause":
            self.playerView.pauseVideo()
        case "Play":
            self.playerView.playVideo()
        case "Stop":
            self.playerView.stopVideo()
            self.playerControl.setTitle("Play", forSegmentAt: 1)
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
        self.loadGoogleAdBanner()
    }
    
    fileprivate func loadGoogleAdBanner() {
        bannerView.adUnitID = "ca-app-pub-6928022194889148/9093399514"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    fileprivate func getPlaylist() {
        Alamofire.request(self.playlistUrl, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let JSON as [String: Any]):
                debugPrint(JSON)
                
                guard let playlist = JSON["playlist"] as? [AnyObject] else {
                    return
                }
                
                self.playlist = playlist.shuffled
                self.url = JSON["url"] as? String
                self.loadSong()
            case .failure(let error):
                print(error)
            default: break
            }
        }
    }
    
    fileprivate func loadSong(_ next: Bool = true) {
        if var idx = playlistIdx {
            idx += next ? 1 : -1
            if (idx < 0) {
                idx = 0
            }
            idx %= (playlist?.count)!
            
            if let videoId = self.playlist?[idx]["id"] as? String {
                self.playlistIdx = idx
                self.playerView.load(withVideoId: videoId, playerVars: self.playerVars)
            }
        }
    }
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        playerView.playVideo()
    }
    
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        if (state == YTPlayerState.ended) {
            self.playerControl.setTitle("Play", forSegmentAt: 1)
            if (self.repeatSong) {
                self.playerView.playVideo()
            }
            else {
                self.loadSong()
            }
        }
        else if (state == YTPlayerState.playing) {
            if (self.playerControl.titleForSegment(at: 1) != "Pause") {
                self.playerControl.setTitle("Pause", forSegmentAt: 1)
            }
        }
        else if (state == YTPlayerState.paused) {
            if (self.playerControl.titleForSegment(at: 1) != "Play") {
                self.playerControl.setTitle("Play", forSegmentAt: 1)
            }
        }
    }
    
    fileprivate func enableBackgroundPlay() {
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
