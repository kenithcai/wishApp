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

class AppUtil
{
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
    
    class func weatherData(city:String)
    {
        let apiId = "12b2817fbec86915a6e9b4dbbd3d9036"
        let urlStr = "http://api.openweathermap.org/data/2.5/weather?q=\(city)&units=metric&appid=\(apiId)"
        let url = NSURL(string: urlStr)!
        guard let data = NSData(contentsOf: url as URL) else { return }
        
        //将获取到的数据转为json对象
//        let jsonData = JSON(data: weatherData)
        let jsonData : AnyObject! = try? JSONSerialization
        .jsonObject(with: data as Data, options:JSONSerialization.ReadingOptions.allowFragments) as AnyObject!

            print(jsonData)
        
        //日期格式化输出
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
        
        print("城市：\(jsonData["name"] as? String)")
        
        let weatherL = jsonData["weather"]as!NSArray
        let weather = (weatherL[0] as AnyObject)["main"]
        print("天气：\(weather)")
        let weatherDes = (weatherL[0] as AnyObject)["description"]
        print("详细天气：\(weatherDes)")
//
        let main = jsonData["main"]as AnyObject
        let temp = main["temp"]as?Int
        print("温度：\(temp)°C")
//
        let humidity = main["humidity"]as?Int
        print("湿度：\(humidity)%")

        let pressure = main["pressure"]as?Int
        print("气压：\(pressure)hpa")

        let wind = jsonData["wind"]as AnyObject
        let windSpeed = wind["speed"]as AnyObject
        print("风速：\(windSpeed)m/s")
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
//        let timeInterval3 = NSTimeInterval(jsonData["dt"].number!)
//        let date3 = NSDate(timeIntervalSince1970: timeInterval3)
//        print("数据时间：\(dformatter.stringFromDate(date3))")
    }
}

