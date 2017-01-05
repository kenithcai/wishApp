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

class MP3PlayerViewController: BaseViewController {

    
    let AV_STATUS = "status"
    let AV_LOADED = "loadedTimeRanges"
    let AV_URLStr = "http://blog.fathoo.xyz/music/%E4%B8%83%E7%99%BE%E5%B9%B4%E5%90%8E.mp3"
    
    @IBOutlet weak var g_avSlide: UISlider!
    @IBOutlet weak var g_musicTitle: UILabel!
    @IBOutlet weak var g_artworkImg: UIImageView!
    @IBOutlet weak var g_curLab: UILabel!
    @IBOutlet weak var g_totalLab: UILabel!
    @IBOutlet weak var g_loadBar: UIProgressView!
//    @IBOutlet weak var g_progressBar: UIProgressView!
    var g_avPlayer:AVPlayer? = nil
    var g_isPlaying:Bool = false
    var g_totalTime:Float64? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.musicInfo(AV_URLStr)
        
        self.slider()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func player()-> AVPlayer
    {
        if g_avPlayer == nil {
            g_avPlayer = AVPlayer()
        }
        return g_avPlayer!
    }
    
    func avItem(_ str:String) -> AVPlayerItem {
        return AVPlayerItem.init(asset: self.avAsset(str))
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
        print(slider.value)
        
        
        let toTime = CMTimeMake(Int64(Float(g_totalTime!)*slider.value) , 1)
        self.player().seek(to: toTime, completionHandler: {_ in
            self.player().play()
        })
    }
    
    
    func playerUrl(_ str:String) {
        self.delObserver()
        let item = self.avItem(str)
        self.player().replaceCurrentItem(with: item)
        self.addObserver()
    }
    
    func musicInfo(_ str:String) {
        
        let asset = self.avAsset(str)
    
        let duration = CMTimeGetSeconds(asset.duration)
        g_totalTime = duration
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
        if g_isPlaying {
            self.player().pause()
        }
        else{
            self.playerUrl(AV_URLStr)
            AppUtil.rotate(g_artworkImg, Float(g_totalTime!/10), g_totalTime!*100)
        }
        
        g_isPlaying = !g_isPlaying
        let img = g_isPlaying ? "player_btn_pause_normal" : "player_btn_play_normal"
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
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
                guard let item = object as? AVPlayerItem else { return }
                if keyPath == AV_LOADED{
                    
                    let array = item.loadedTimeRanges
                    let timeRange = array.first?.timeRangeValue
                    
                    let totalBuffer = CMTimeGetSeconds((timeRange?.start)!) + CMTimeGetSeconds((timeRange?.duration)!)
                    let duration = CMTimeGetSeconds(item.duration)
                    
                    let scale = totalBuffer/duration
                    self.g_loadBar.setProgress(Float(scale), animated: true)
                    
                    
//                    let cur = self.g_avPlayer?.currentTime().value/self.g_avPlayer?.currentTime().timescale
                    print("totalbuffer === ",totalBuffer)
//                    if totalBuffer > 5
//                    {
//                        self.player().play()
//                    }
                }
                else if keyPath == AV_STATUS{
                    // 监听状态改变
                    if item.status == AVPlayerItemStatus.readyToPlay{
                        // 只有在这个状态下才能播放
                        self.player().play()
                    }else{
                        print("加载异常")
                    }
                }
    }
    
    
    func addObserver() {
        self.player().currentItem?.addObserver(self, forKeyPath: AV_STATUS, options: NSKeyValueObservingOptions.new, context: nil)
        self.player().currentItem?.addObserver(self, forKeyPath: AV_LOADED, options: NSKeyValueObservingOptions.new, context: nil)
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil, using: {_ in
            print("播放完成")
        })
        // 进度条
        self.player().addPeriodicTimeObserver(forInterval: CMTimeMake(1, 1), queue: nil, using: {time in
            let current = CMTimeGetSeconds(time)
//            self.g_progressBar.progress = Float(current / self.g_totalTime!)
            self.g_curLab.text = AppUtil.converTime(Float(current))
            self.g_avSlide.setValue(Float(current / self.g_totalTime!), animated: true)
            if Float(current / self.g_totalTime!) >= 1{
                NotificationCenter.default.post(name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
            }
        })
    }
    
    func delObserver(){
        g_avPlayer?.currentItem?.removeObserver(self, forKeyPath: AV_STATUS)
        g_avPlayer?.currentItem?.removeObserver(self, forKeyPath: AV_LOADED)
        
        NotificationCenter.default.removeObserver(NSNotification.Name.AVPlayerItemDidPlayToEndTime)
//        No
//        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
//        [self.player removeTimeObserver:self.timeObserver];
    }
}
