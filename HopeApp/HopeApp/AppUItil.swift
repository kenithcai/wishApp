//
//  AppUItil.swift
//  工具类
//  HopeApp
//
//  Created by KenithCai on 16/11/17.
//  Copyright © 2016年 KenithCai. All rights reserved.
//

import Foundation
import UIKit

let GaussianBlurTag = 1000
struct WeatherInfo
{
    var city = ""
    var weather = ""
    var time = ""
    var temp = ""
}

extension String {
    
    func transformToPinYin() -> String {
        
        let mutableString = NSMutableString(string: self)

        //把汉字转为拼音
        CFStringTransform(mutableString, nil, kCFStringTransformToLatin, false)
        //去掉拼音的音标
        CFStringTransform(mutableString, nil, kCFStringTransformStripDiacritics, false)
        
        let string = String(mutableString).replacingOccurrences(of: " shi", with: "")
        //去掉空格
        return string.replacingOccurrences(of: " ", with: "")
//        return string.stringByReplacingOccurrencesOfString(" ", withString: "")
    }
}

extension UIImage {
    
    /// 将当前图片缩放到指定宽度
    ///
    /// - parameter width: 指定宽度
    ///
    /// - returns: UIImage，如果本身比指定的宽度小，直接返回
    func scaleImageToWidth(_ width: CGFloat) -> UIImage {
        
        // 1. 判断宽度，如果小于指定宽度直接返回当前图像
        if size.width < width {
            return self
        }
        
        // 2. 计算等比例缩放的高度
        let height = width * size.height / size.width
        
        // 3. 图像的上下文
        let s = CGSize(width: width, height: height)
        // 提示：一旦开启上下文，所有的绘图都在当前上下文中
        UIGraphicsBeginImageContext(s)
        
        // 在制定区域中缩放绘制完整图像
        draw(in: CGRect(origin: CGPoint.zero, size: s))
        
        // 4. 获取绘制结果
        let result = UIGraphicsGetImageFromCurrentImageContext()
        
        // 5. 关闭上下文
        UIGraphicsEndImageContext()
        
        // 6. 返回结果
        return result!
    }
}

class AppUtil
{
    struct Platform {
        static let isSimulator: Bool = {
            var isSim = false
            #if arch(i386) || arch(x86_64)
                isSim = true
            #endif
            return isSim
        }()
    }
    class func simulator()->Bool
    {
        return Platform.isSimulator
    }
    
    typealias FuncBlock = ()->()
    
    //创建高斯模糊效果的背景
    class func gaussianBlur (view:UIImageView)
    {
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light)) as UIVisualEffectView
        
        visualEffectView.frame = view.bounds
        visualEffectView.tag = GaussianBlurTag
        view.addSubview(visualEffectView)
    }
    
    //在一个界面上跳第二个界面
    class func addView (vc:UIViewController, name:String, closure:@escaping AppUtil.FuncBlock = {})
    {
        let story = UIStoryboard(name:"Main",bundle:nil)
        let rec = story.instantiateViewController(withIdentifier: name)as?BaseViewController
        rec?.modalPresentationStyle = .custom
        rec?.providesPresentationContextTransitionStyle = true
        rec?.definesPresentationContext = true
        rec?.setClosure (closure: closure)
        vc.present(rec!, animated: true)
    }
    
    
    
    // 获取Uid
    class func uid()->String
    {
        if Platform.isSimulator {
            return "1111"
        }
        
        return CMUUIDManager.readUUID() as! String
    }
    // 截全屏
    class func screenShots()->UIImage
    {
        let window = UIApplication.shared.keyWindow
        return AppUtil.screenShotsWithRect(rect: (window?.bounds)!)
    }
    
    // 截区域
    class func screenShotsWithRect(rect:CGRect)->UIImage
    {
        let window = (UIApplication.shared.keyWindow)!as UIWindow
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        context!.saveGState()
        context!.translateBy(x: -rect.origin.x, y: -rect.origin.y)
        
        if window.responds(to: #selector(UIView.drawHierarchy(in:afterScreenUpdates:))) {
            window.drawHierarchy(in: window.bounds, afterScreenUpdates: false)
        }else
        {
            window.layer.render(in: UIGraphicsGetCurrentContext()!)
        }
        context!.restoreGState()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    // 天气数据
    class func weatherData(city:String, handler: @escaping (WeatherInfo?)->Void)
    {
        
    }
    
    // 天气情况
    class func weatherToCN(_ weather:String)->String
    {
        var dic:Dictionary<String,String>=["Wind":"阵风","Clouds":"多云","Rain":"有雨","Snow":"下雪", "Haze":"阴霾", "Clear":"晴天", "Mist" : "雾"];
        let info = dic[weather]
        return (info != nil) ? info! : weather
    }
    
    class func weatherData(city:String, info:inout WeatherInfo)
    {
        let apiId = "12b2817fbec86915a6e9b4dbbd3d9036"
        let urlStr = "http://api.openweathermap.org/data/2.5/weather?q=\(city)&units=metric&appid=\(apiId)"
        let url = NSURL(string: urlStr)!
        guard let data = NSData(contentsOf: url as URL) else { return }
        
        //将获取到的数据转为json对象
        let jsonData : AnyObject! = try? JSONSerialization
        .jsonObject(with: data as Data, options:JSONSerialization.ReadingOptions.allowFragments) as AnyObject!

            print(jsonData)
        
        let weatherL = jsonData["weather"]as!NSArray
        let weather = (weatherL[0] as AnyObject)["main"]
        
        let main = jsonData["main"]as AnyObject
        let temp = main["temp"]as?Int
        
        //日期格式化输出
        let dformatter = DateFormatter()
//        dformatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
        dformatter.dateFormat = "yyyy/MM/dd"
        
        let timeInterval3 = TimeInterval(jsonData["dt"] as!Int)
        let date3 = NSDate(timeIntervalSince1970: timeInterval3)
        
        
        info.weather = weather as! String
        info.temp = String.init(format: "%d°C", temp!)
        info.time = dformatter.string(from: date3 as Date)
//        let weatherDes = (weatherL[0] as AnyObject)["description"]
//        print("详细天气：\(weatherDes)")
        
//
//        let humidity = main["humidity"]as?Int
//        print("湿度：\(humidity)%")
//
//        let pressure = main["pressure"]as?Int
//        print("气压：\(pressure)hpa")
//
//        let wind = jsonData["wind"]as AnyObject
//        let windSpeed = wind["speed"]as AnyObject
//        print("风速：\(windSpeed)m/s")
//
//        let lon = jsonData["coord"]["lon"].number!
//        let lat = jsonData["coord"]["lat"].number!
//        print("坐标：[\(lon),\(lat)]")
//        
//        let timeInterval1 = NSTimeInterval(jsonData["sys"]["sunrise"].number!)
//        let date1 = NSDate(timeIntervalSince1970: timeInterval1)
//        print("日出时间：\(dformatter.stringFromDate(date1))")
//        
//        let timeInterval2 = NSTimeInterval(jsonData["sys"]["sunset"].number!)
//        let date2 = NSDate(timeIntervalSince1970: timeInterval2)
//        print("日落时间：\(dformatter.stringFromDate(date2))")
//        
        
    }
    
    // 下雪特效
    class func snowAct(view:UIImageView)
    {
        let rect = CGRect(x: 0.0, y: -70.0, width: view.bounds.width,
                          height: 50.0)
        let emitter = CAEmitterLayer()
        emitter.frame = rect
        view.layer.addSublayer(emitter)
        emitter.emitterShape = kCAEmitterLayerRectangle
        
        //kCAEmitterLayerPoint
        //kCAEmitterLayerLine
        //kCAEmitterLayerRectangle
        
        emitter.emitterPosition = CGPoint(x:rect.width/2, y:rect.height/2)
        emitter.emitterSize = rect.size
        
        let emitterCell = CAEmitterCell()
        emitterCell.contents = UIImage(named: "xh")?.scaleImageToWidth(30).cgImage
        
        emitterCell.birthRate = 5  //每秒产生120个粒子
//        emitterCell.speed           = 10
        emitterCell.velocity = 2.0 //初始速度
        emitterCell.velocityRange = 10.0   //随机速度 -200+20 --- 200+20
//        emitterCell.xAcceleration = 0.0 //x方向一个加速度
        emitterCell.yAcceleration = 10.0  //给Y方向一个加速度
        emitterCell.emissionRange = CGFloat(M_PI_2) //随机方向 -pi/2 --- pi/2
        emitterCell.spin = 2 //旋转速度
        emitterCell.spinRange = 0.25 * CGFloat(M_PI);
        
        emitterCell.lifetime = 10    //存活1秒
        emitterCell.lifetimeRange = 3.0
        
        emitterCell.scale = 0.8
        emitterCell.scaleRange = 0.8  //0 - 1.6
        emitterCell.scaleSpeed = -0.1  //逐渐变小

        emitterCell.alphaRange = 0.75   //随机透明度
        emitterCell.alphaSpeed = -0.1  //逐渐消失
//        emitterCell.emissionLongitude = CGFloat(-M_PI) //向左
        
        
        
//        emitterCell.color = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).cgColor //指定颜色
//        emitterCell.redRange = 1.0
//        emitterCell.greenRange = 0.3
//        emitterCell.blueRange = 0.3  //三个随机颜色
        
        emitter.emitterCells = [emitterCell]  //这里可以设置多种粒子 我们以一种为粒子
    }
    
    // http get请求
    class func likeApp(_ cid:Int, _ uid:String, handler: @escaping (URL?,Data?)->Void)
    {
        let urlStr:NSString = String(format:"http://blog.fathoo.xyz/index.php?a=hope&m=giveLike&id=%d&device_id=%@",cid,uid) as NSString
        let url:NSURL = NSURL(string: urlStr as String)!
        if let jsonData = NSData(contentsOf: url as URL)
        {
            handler(url as URL,jsonData as Data)
        }
        
        //(2) 创建请求对象
        //        let request:NSURLRequest = NSURLRequest(url: url as URL)
        //(3) 发送请求
        //NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue:OperationQueue(), completionHandler: handler)
    }
    
    // 提示框(2s后消失)
    class func alert(_ title:String,_ target:UIViewController)
    {
        let alertController = UIAlertController(title: title,
                                                message: nil, preferredStyle: .alert)
        //显示提示框
        target.present(alertController, animated: true, completion: nil)
        //两秒钟后自动消失
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2)
        {
            target.presentedViewController?.dismiss(animated: false, completion: nil)
        }
    }
    
    // 旋转动画
    class func rotate(_ view:UIView, _ duration:Float)
    {
        let ani = CABasicAnimation(keyPath: "transform.rotation")
        ani.toValue = M_PI * 2
        ani.duration = CFTimeInterval(duration)
        ani.repeatCount = MAXFLOAT
        
        view.layer.add(ani, forKey: "Rotation")
//        UIView.animate(withDuration: TimeInterval(duration), delay: 0, options: .curveLinear, animations: {
//            view.transform = view.transform.rotated(by: CGFloat(M_PI_2))
//        }) { (finish: Bool) in
//            AppUtil.rotate(view,duration)
//        }
    }
    
    // 秒转日期时间字符串
    class func converTime(_ second:Float) -> String {
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
    }
}

