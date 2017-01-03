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
    
    @IBOutlet weak var g_curLab: UILabel!
    @IBOutlet weak var g_totalLab: UILabel!
    @IBOutlet weak var g_loadBar: UIProgressView!
    @IBOutlet weak var g_progressBar: UIProgressView!
    var g_avPlayer:AVPlayer? = nil
    var g_isPlaying:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func clickType(_ sender: UIButton) {
    }
    @IBAction func clickPre(_ sender: UIButton) {
    }
    @IBAction func clickPlay(_ sender: UIButton) {
        if g_avPlayer == nil {
            let url:NSURL = NSURL(string: "http://blog.fathoo.xyz/music/%E4%B8%83%E7%99%BE%E5%B9%B4%E5%90%8E.mp3" as String)!
            g_avPlayer = AVPlayer.init(url: url as URL)
            g_avPlayer?.currentItem?.addObserver(self, forKeyPath: AV_STATUS, options: NSKeyValueObservingOptions.new, context: nil)
            g_avPlayer?.currentItem?.addObserver(self, forKeyPath: AV_LOADED, options: NSKeyValueObservingOptions.new, context: nil)
        }
        if g_isPlaying {
            g_avPlayer?.pause()
        }
        else{
            g_avPlayer?.play()
            
            g_avPlayer?.addPeriodicTimeObserver(forInterval: CMTimeMake(1, 1), queue: nil, using: {time in
                let current = CMTimeGetSeconds(time)
                let total = CMTimeGetSeconds((self.g_avPlayer?.currentItem?.duration)!)
                self.g_progressBar.progress = Float(current / total)
                self.g_curLab.isHidden = false
                self.g_curLab.text = self.convertime(CGFloat(current))
            })
        }
        
        g_isPlaying = !g_isPlaying
    }
    @IBAction func clickNext(_ sender: UIButton) {
    }
    @IBAction func clickList(_ sender: UIButton) {
    }
    @IBAction func clickCloseBtn(_ sender: UIButton) {
        if (g_closeFunc != nil) {
            g_closeFunc!()
        }
        //        self.modalTransitionStyle = .crossDissolve
        //        UIView.setAnimationTransition
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
                    print("toalBuffer ====",totalBuffer)
                    
                }else if keyPath == AV_STATUS{
                    // 监听状态改变
                    if item.status == AVPlayerItemStatus.readyToPlay{
                        // 只有在这个状态下才能播放
                        self.g_avPlayer?.play()
                        let duration = CMTimeGetSeconds(item.duration)
                        self.g_totalLab.isHidden = false
                        self.g_totalLab.text = self.convertime(CGFloat(duration))
//                        print("all time = ",duration,self.convertime(CGFloat(duration)))
                    }else{
                        print("加载异常")
                    }
                }
    }
    
    func deleteObs(){
        g_avPlayer?.currentItem?.removeObserver(self, forKeyPath: AV_STATUS)
        g_avPlayer?.currentItem?.removeObserver(self, forKeyPath: AV_LOADED)
    }
    
    func convertime(_ second:CGFloat) -> String {
        let time = TimeInterval(second)
        let date = NSDate(timeIntervalSince1970: time)
        let dfm = DateFormatter()
        if (second/3600 >= 1) {
            dfm.dateFormat = "HH:mm:ss"
        } else {
            dfm.dateFormat = "mm:ss"
        }
    
        let timeStr = dfm.string(from: date as Date)
        return timeStr
//        dformatter.string(from: date3 as Date)
    }
//    - (NSString *)convertTime:(CGFloat)second{
//    NSDate *d = [NSDate dateWithTimeIntervalSince1970:second];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    if (second/3600 >= 1) {
//    [formatter setDateFormat:@"HH:mm:ss"];
//    } else {
//    [formatter setDateFormat:@"mm:ss"];
//    }
//    NSString *showtimeNew = [formatter stringFromDate:d];
//    return showtimeNew;
//    }
}
