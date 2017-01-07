//
//  MP3PlayerViewController.swift
//  HopeApp
//
//  Created by KenithCai on 17/1/3.
//  Copyright © 2017年 KenithCai. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

public enum PlayState : Int {
    case stop
    
    case pause
    
    case playing
}

class MP3PlayerViewController: BaseViewController,AQPlayerDelegate {

    
    let AV_STATUS = "status"
    let AV_LOADED = "loadedTimeRanges"
    let AV_KEEPUP = "playbackLikelyToKeepUp"
    let AV_URLStr = "http://blog.fathoo.xyz/music/%E4%B8%83%E7%99%BE%E5%B9%B4%E5%90%8E.mp3"
    
    @IBOutlet weak var g_avSlide: UISlider!
    @IBOutlet weak var g_musicTitle: UILabel!
    @IBOutlet weak var g_artworkImg: UIImageView!
    @IBOutlet weak var g_curLab: UILabel!
    @IBOutlet weak var g_totalLab: UILabel!
    @IBOutlet weak var g_loadBar: UIProgressView!

    var g_totalTime:Float = 0.0
    let g_AVplayer = AQPlayer.shared()!
    var g_AVstate:PlayState = .stop
    var g_AVtimeStop:Bool = true
    var g_AVtimer:Timer? = nil
    var g_AVcurTime:Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.musicInfo(AV_URLStr)
        
        self.slider()
        
        g_AVplayer.delegate = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func avAsset(_ str:String) -> AVURLAsset {
        return AVURLAsset.init(url: NSURL(string: str)! as URL)
    }
    
    func slider()
    {
        g_avSlide.isContinuous = false
        g_avSlide.addTarget(self, action: #selector(sliderValueChange(_:)), for: UIControlEvents.valueChanged)
    }
    func sliderValueChange(_ slider:UISlider){
        let toTime = CMTimeMake(Int64(Float(g_totalTime)*slider.value) , 1)
        self.g_AVcurTime = Float(toTime.value)
        self.g_AVplayer.seek(TimeInterval(self.g_AVcurTime))
    }
    
    
    func playUrl(_ str:String) {
        self.delObserver()
        g_AVplayer.play(AV_URLStr)
        self.addObserver()
    }
    
    func resume() {
        g_AVplayer.play()
    }
    func playNext() {
        
    }
    
    func musicInfo(_ str:String) {
        
        let asset = self.avAsset(str)
    
        let duration = CMTimeGetSeconds(asset.duration)
        g_totalTime = Float(duration)
        self.g_totalLab.text = AppUtil.converTime(Float(duration))
        self.g_curLab.text = "00:00"
        for var format in asset.availableMetadataFormats {
            for var data in asset.metadata(forFormat: format) {
                if data.commonKey == "title" {
                    self.g_musicTitle.isHidden = false
                    self.g_musicTitle.textAlignment = .center
                    self.g_musicTitle.text = data.value as! String?
                }
                
                if data.commonKey == "artwork" {
                    let data = data.value
                    let img = UIImage.init(data:data as! Data)
                    self.g_artworkImg.image = img
                    self.g_artworkImg.contentMode = .scaleAspectFill
                    self.g_artworkImg.layer.masksToBounds = true
                    self.g_artworkImg.layer.cornerRadius = self.g_artworkImg.bounds.size.height/2
                    
                }
            }
        }
    }

    @IBAction func clickType(_ sender: UIButton) {
    }
    @IBAction func clickPre(_ sender: UIButton) {
    }
    @IBAction func clickPlay(_ sender: UIButton) {
        if self.g_AVstate == .stop {
            self.g_AVstate = .playing
            self.playUrl(AV_URLStr)
            AppUtil.rotate(g_artworkImg, 6.0)
        }else if self.g_AVstate == .pause {
            self.g_AVstate = .playing
            self.resume()
            AppUtil.rotate(g_artworkImg, 6.0)
        }
        else{
            self.g_AVstate = .pause
            self.g_AVplayer.stop()
//            g_artworkImg.layer.removeAllAnimations();
            g_artworkImg.stopAnimating()
        }
        
        let img = self.g_AVstate == .playing ? "player_btn_pause_normal" : "player_btn_play_normal"
        sender.setImage(UIImage.init(named: img), for: .normal)
    }
    @IBAction func clickNext(_ sender: UIButton) {
    }
    @IBAction func clickList(_ sender: UIButton) {
    }
    @IBAction func clickCloseBtn(_ sender: UIButton) {
        if (g_closeFunc != nil) {
            g_closeFunc!()
        }
        self.dismiss(animated: true, completion: nil)
    }
    func addObserver() {
        
        g_AVtimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }
    
    func delObserver(){
        g_AVtimer?.invalidate()
    }
    
    func update() {
        if self.g_AVstate == .playing {
            if self.g_AVcurTime > self.g_totalTime {
                self.playNext()
            }else {
                if self.g_AVtimeStop {
                    return
                }
                self.g_AVcurTime += 1
                
                if self.g_AVcurTime < self.g_totalTime {
                    self.performSelector(onMainThread: #selector(updateUI), with: nil, waitUntilDone: false)
                }
            }
        }
    }
    
    func updateUI() {
        self.g_curLab.text = AppUtil.converTime(self.g_AVcurTime)
        self.g_avSlide.setValue(self.g_AVcurTime / self.g_totalTime, animated: true)

    }
    
    func aqPlayer(_ player: AQPlayer!, duration d: TimeInterval, zeroCurrentTime flag: Bool) {
        
        if flag {
            self.g_AVcurTime = 0.0;
        }
        self.g_totalTime = Float(d)
        self.g_AVstate = .playing
        self.g_AVtimeStop = false
    }
    
    func aqPlayer(_ player: AQPlayer!, timerStop flag: Bool) {
        self.g_AVstate = .playing
        self.g_AVtimeStop = flag
    }
    
    func aqPlayer(_ player: AQPlayer!, playNext flag: Bool) {
        self.playNext()
    }
}
