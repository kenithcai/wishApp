//
//  ViewController.swift
//  HopeApp
//
//  Created by KenithCai on 16/11/5.
//  Copyright © 2016年 KenithCai. All rights reserved.
//

import UIKit
import Kingfisher
import Alamofire
import CoreFoundation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        g_imageView = g_bgImg
        //网络请求
        self.reloadData()
        let path = MyTool.makePlist(inTmp: "checkDown.plist")
        MyTool.addValue(path, key: "test4", value: "1234")
    }
    
    
    var g_screenSize:CGRect = UIScreen.main.bounds
    var g_imageView:UIImageView? = nil
    var g_likeBtn:UIButton? = nil
    var g_weatherInfo:WeatherInfo = WeatherInfo()
    var g_likeCount:Int = 0
    var g_contentId:Int = 0
    
    @IBOutlet weak var g_bgImg: UIImageView!
    @IBOutlet weak var g_weatherLab: UILabel!
    @IBOutlet weak var g_contentLab: MyLabel!
    @IBOutlet weak var g_shareBtn: UIButton!
    @IBOutlet weak var g_settingBtn: UIButton!
    @IBOutlet weak var g_likeNum: UILabel!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    let formatUrl = "http://blog.fathoo.xyz/index.php?a=hope&m=getSencence&device_id=%@"
    func reloadData()
    {
        let url = String.init(format: formatUrl, AppUtil.uid())
        Alamofire.request(url, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil
                {
                    let json = response.result.value as? [String:AnyObject]
                    print(json)
                    let content = json?["content"] as? String
                    let picUrl = json?["picture"] as? String
//                    let time = json?["release_date"] as? String
//                    print("content:\(content), pic:\(picUrl),time:\(time)")
                    let author = json?["author"] as? String
                    let canLike = json?["can_give_like"] as? NSNumber
                    let num = json?["like"] as? Int
                    self.g_likeCount = num!
                    self.g_contentId = (json?["id"] as? Int)!
                    // 显示图片
                    self.showImg(picUrl)
                    if picUrl == nil {
                        return
                    }
                    // 显示文字
                    self.showLab(content, author: author)
                    // 显示天气
                    self.showWeather()
                    // 是否可点赞
                    self.showCanLike(canLike?.intValue == 1)
                }
                break
                
            case .failure(_):
                print(response.result.error ?? "出错")
                break
                
            }
        }
    }
    
    func showImg(_ imgUrl:String?)
    {
        if nil == imgUrl
        {
            return
        }
        
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0,y: 0,width: g_screenSize.width,height: g_screenSize.height)
        imageView.contentMode = .scaleAspectFit
        self.view.insertSubview(imageView, at: 0)
        imageView.kf.setImage(with: URL(string: imgUrl!)!)
        g_imageView = imageView
    }
    
    func showLab(_ content:String?, author:String?)
    {
        if nil == content {
            return
        }
        g_contentLab.sizeToFit()
        g_contentLab.verStyle = top
        g_contentLab.text = content
        g_contentLab.isHidden = false
        
        if nil == author {
            return
        }
        
//        「」『』
        let rect = g_contentLab.bounds
        var str = author

        str?.insert("『", at: (str?.startIndex)!)
        str?.insert("—", at: (str?.startIndex)!)
        str?.insert("—", at: (str?.startIndex)!)
        str?.insert("』", at: (str?.endIndex)!)
        
        let lab=UILabel(frame:CGRect(x: 0, y:rect.height+10, width: g_screenSize.width-60, height: 16))
        lab.textAlignment = NSTextAlignment.right
        lab.lineBreakMode = .byWordWrapping
        lab.numberOfLines = 0
        lab.text = str
        g_contentLab.addSubview(lab)

    }
    
    func showWeather()
    {
        // TODO:test1
        AppUtil.snowAct(view: g_imageView!)
        
        LocationMgr.instance.city() { (city) in
            self.g_weatherInfo.city = city!
            AppUtil.weatherData(city:(city?.transformToPinYin())!,info: &self.g_weatherInfo)
            let str = String.init(format: "%@    %@    %@    %@",
                                  self.g_weatherInfo.city,
                                  AppUtil.weatherToCN(self.g_weatherInfo.weather),
                                  self.g_weatherInfo.temp,
                                  self.g_weatherInfo.time)
            self.g_weatherLab.isHidden = false
            self.g_weatherLab.textAlignment = NSTextAlignment.center
            self.g_weatherLab.numberOfLines = 0
            self.g_weatherLab.text = str
        }
    }
    func showCanLike(_ canLike:Bool)
    {
        // 按钮状态
        if g_likeBtn == nil
        {
            g_likeBtn = UIButton(type: .custom)
            g_likeBtn?.isEnabled = true
            g_likeBtn?.addTarget(self, action:#selector(clickLike(_:)), for:.touchUpInside)
            self.view.addSubview(g_likeBtn!);
        }
        // 按钮状态
        if canLike == true
        {
            g_likeBtn?.setImage(UIImage.init(named: "btn_unlike"), for: .normal)
        }
        else
        {
            g_likeBtn?.setImage(UIImage.init(named: "btn_like"), for: .normal)
        }
    
        // 点赞数量
        var str = String.init(format: "%d", self.g_likeCount)
        if self.g_likeCount > 999 {
            str = String.init(format: "%d⁺", 999)
        }
        g_likeNum.textAlignment = NSTextAlignment.right
        g_likeNum.isHidden = false
        g_likeNum.text = str
        g_likeNum.sizeToFit()
        
        // 按钮位置
        let rect = g_likeNum.bounds
        g_likeBtn?.frame = CGRect(x:g_screenSize.size.width-20-10-rect.size.width, y:g_screenSize.size.height-5-rect.size.height, width:20, height:21)
    }
    
    // 显示隐藏界面上的东西
    func hiddenInfo(hidden: Bool)
    {
        let views = self.view.subviews
        
        for child in views
        {
            if child != g_imageView {
                child.isHidden = hidden
            }
        }
        if (g_imageView == nil)
        {
            return
        }
        let view = g_imageView!.viewWithTag(GaussianBlurTag)
        if (view != nil) {
            view?.removeFromSuperview()
        }
        
    }
    // 分享
    @IBAction func clickShare(_ sender: UIButton) {
        
        if g_imageView == nil {
            return
        }
        
        self.hiddenInfo(hidden: true)
        
        AppUtil.gaussianBlur(view: g_imageView!)
        AppUtil.addView(vc: self, name: "ShareViewController",closure: {self.hiddenInfo(hidden: false)})
        
//        WeixinSdk.instance().sendText("哈哈test", in: WXSceneSession)
//        let path = Bundle.main.path(forResource: "preset_bg_7", ofType: "jpg")
//        let img = AppUtil.screenShots()
        
        let img = AppUtil.screenShots()
        WeixinSdk.instance().sendImg(UIImagePNGRepresentation(img), in: WXSceneTimeline)
    }
    // 设置页面
    @IBAction func clickSetting(_ sender: UIButton) {
        
        if g_imageView != nil {
            self.hiddenInfo(hidden: true)
            
            AppUtil.gaussianBlur(view: g_imageView!)
        }
        
//        AppUtil.addView(vc: self, name: "SettingViewController",closure: {self.hiddenInfo(hidden: false)})
        AppUtil.addView(vc: self, name: "MP3PlayerViewController",closure: {self.hiddenInfo(hidden: false)})

    }
    @IBAction func clickLike(_ sender: UIButton) {
//        0：点赞成功
//        1001：已点过赞
//        1002：数据异常
        AppUtil.likeApp(self.g_contentId, AppUtil.uid(), handler: { (url, data) in
            let json = try? JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String: Any]
            print(json)
            let code = json?["code"]as! NSNumber
            let num = json?["like"]as! Int
            if code.intValue == 0
            {
                self.g_likeCount = num
                self.showCanLike(false)
            }
            else
            {
                let str = code.intValue == 1001 ? "您已点赞" : "数据异常"
                AppUtil.alert(str, self)
            }
        })
    }
}

