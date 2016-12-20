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
        
        //网络请求
        self.reloadData()
    }
    
    
    var g_screenSize:CGRect = UIScreen.main.bounds
    var g_imageView:UIImageView? = nil
    var g_labView:UILabel? = nil
    var g_weatherInfo:WeatherInfo = WeatherInfo()
    
    @IBOutlet weak var g_weatherLab: UILabel!
    @IBOutlet weak var g_contentLab: MyLabel!
    @IBOutlet weak var g_shareBtn: UIButton!
    @IBOutlet weak var g_settingBtn: UIButton!

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    let formatUrl = "http://blog.fathoo.xyz/index.php?a=hope&m=getSencence&device_id=%@"
    func reloadData()
    {
        // TODO:test
        let url = String.init(format: formatUrl, "1111111111111")
//        let url = String.init(format: formatUrl, AppUtil.uid())
        Alamofire.request(url, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil
                {
                    let json = response.result.value as? [String:AnyObject]
                    let content = json?["content"] as? String
                    let picUrl = json?["picture"] as? String
//                    let time = json?["release_date"] as? String
//                    print("content:\(content), pic:\(picUrl),time:\(time)")
                    let author = json?["author"] as? String
                    let canLike = json?["can_give_like"] as? Bool
                    // 显示图片
                    self.showImg(picUrl)
                    // 显示文字
                    self.showLab(content, author: author)
                    // 显示天气
                    self.showWeather()
                    // 是否可点赞
                    self.showCanLike(canLike!)
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
        
        let city = "guangzhou"
        self.g_weatherInfo.city = city
        AppUtil.weatherData(city:(city.transformToPinYin()),info: &self.g_weatherInfo)
        print("aaaaaaaaaaaaaaaaaa",self.g_weatherInfo.city,self.g_weatherInfo.temp,self.g_weatherInfo.weather,self.g_weatherInfo.time)
        let str = String.init(format: "%@    %@    %@   %@",
                              self.g_weatherInfo.city,
                              AppUtil.weatherToCN(self.g_weatherInfo.weather),
                              self.g_weatherInfo.temp,
                              self.g_weatherInfo.time)
        self.g_weatherLab.isHidden = false
        self.g_weatherLab.textAlignment = NSTextAlignment.right
        self.g_weatherLab.text = str
        
        LocationMgr.instance.city() { (city) in
            print(city)
            print(city?.transformToPinYin())
            self.g_weatherInfo.city = city!
            AppUtil.weatherData(city:(city?.transformToPinYin())!,info: &self.g_weatherInfo)
            print("aaaaaaaaaaaaaaaaaa",self.g_weatherInfo.city,self.g_weatherInfo.temp,self.g_weatherInfo.weather,self.g_weatherInfo.time)
            let str = String.init(format: "%@    %@    %@    %@",
                                  self.g_weatherInfo.city,
                                  AppUtil.weatherToCN(self.g_weatherInfo.weather),
                                  self.g_weatherInfo.temp,
                                  self.g_weatherInfo.time)
            self.g_weatherLab.isHidden = false
            self.g_weatherLab.textAlignment = NSTextAlignment.center
//            self.g_weatherLab.lineBreakMode = .byWordWrapping
            self.g_weatherLab.numberOfLines = 0
            self.g_weatherLab.text = str
//            print("aaaaaaaaaaaaaaaaaa",self.g_weatherInfo.city,self.g_weatherInfo.temp,self.g_weatherInfo.weather,self.g_weatherInfo.time)
            
        }
    }
    func showCanLike(_ canLike:Bool)
    {
        
    }
    
    // 显示隐藏界面上的东西
    func hiddenInfo(hidden: Bool)
    {
        g_settingBtn.isHidden = hidden
        g_shareBtn.isHidden = hidden
        g_labView?.isHidden = hidden
        
        if (g_imageView == nil) {
            return
        }
        let view = g_imageView!.viewWithTag(GaussianBlurTag)
        if (view != nil) {
            view?.removeFromSuperview()
        }
    }
    // 分享
    @IBAction func clickShare(_ sender: UIButton) {
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
        
        self.hiddenInfo(hidden: true)

        AppUtil.gaussianBlur(view: g_imageView!)
        AppUtil.addView(vc: self, name: "SettingViewController",closure: {self.hiddenInfo(hidden: false)})

    }
    @IBAction func clickLike(_ sender: UIButton) {
        print("aaaaaaaaaaaaaaaaaa",g_weatherInfo.city,g_weatherInfo.temp,g_weatherInfo.weather,g_weatherInfo.time)
//        0：点赞成功
//        1001：已点过赞
//        1002：数据异常
        AppUtil.likeApp(uid: AppUtil.uid(), handler: { (url, data) in
            let json = try? JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String: Any]
            let code = json?["code"]as! NSNumber
            print(code)
        })
    }
}

