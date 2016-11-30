//
//  WeatherMgr.swift
//  HopeApp
//
//  Created by KenithCai on 16/11/30.
//  Copyright © 2016年 KenithCai. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class WeatherMgr: NSObject,CLLocationManagerDelegate {
    
    //保存获取到的本地位置
    var m_curLocation : CLLocation!
    
    //用于定位服务管理类，它能够给我们提供位置信息和高度信息，也可以监控设备进入或离开某个区域，还可以获得设备的运行方向
    var m_locationMgr : CLLocationManager = CLLocationManager()
    
    static let instance = WeatherMgr()
    private override init() {
        super.init()
        
        m_locationMgr = CLLocationManager()
        
        //精度最高
        m_locationMgr.desiredAccuracy = kCLLocationAccuracyBest
        
        //距离改变1000 米后再次定位
        m_locationMgr.distanceFilter = 1000
        
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.notDetermined {
            m_locationMgr.requestWhenInUseAuthorization()
        }
        m_locationMgr.delegate = self
        
        m_locationMgr.startUpdatingLocation()
    }
    
    
    func initLocation() {
        m_locationMgr.delegate = self
        m_locationMgr.requestAlwaysAuthorization()
        //设备使用电池供电时最高的精度
        m_locationMgr.desiredAccuracy = kCLLocationAccuracyBest
        //精确到1000米,距离过滤器，定义了设备移动后获得位置信息的最小距离
        m_locationMgr.distanceFilter = kCLLocationAccuracyKilometer
        
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.notDetermined {
            m_locationMgr.requestWhenInUseAuthorization()
        }
        
        //距离改变1000 米后再次定位
        m_locationMgr.distanceFilter = 1000
        //使用应用程序期间允许访问位置数据
        m_locationMgr.requestWhenInUseAuthorization()
        m_locationMgr.startUpdatingLocation()
    }
    
    //MARK:- 实现CLLocationManagerDelegate协议
    open func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        m_curLocation = locations.last as! CLLocation
        print(m_curLocation.coordinate.longitude)
        print(m_curLocation.coordinate.latitude)
        LonLatToCity()
    }
    
    open func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        <span style="white-space:pre">	</span>//获取失败，可能是关闭了定位服务
        print(error)
    }
    
    ///将经纬度转换为城市名
    func LonLatToCity() {
        let geocoder: CLGeocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(m_locationMgr.location!, completionHandler: { (placemark, error) -> Void in
            if (error == nil) {//转换成功，解析获取到的各个信息
                let array = placemark
//                let mark = array.first as! CLPlacemark
                let mark = (array?.first!)! as CLPlacemark
                print(mark)

//                var city: String = (mark.addressDictionary as NSDictionary).valueForKey("City") as! String
//                let country: NSString = (mark.addressDictionary as NSDictionary).valueForKey("Country") as! NSString
//                let CountryCode: NSString = (mark.addressDictionary as NSDictionary).valueForKey("CountryCode") as! NSString
//                let FormattedAddressLines: NSString = (mark.addressDictionary as NSDictionary).valueForKey("FormattedAddressLines")?.firstObject as! NSString
//                let Name: NSString = (mark.addressDictionary as NSDictionary).valueForKey("Name") as! NSString
//                var State: String = (mark.addressDictionary as NSDictionary).valueForKey("State") as! String
//                let SubLocality: NSString = (mark.addressDictionary as NSDictionary).valueForKey("SubLocality") as! NSString
                
                //去掉“市”和“省”字眼
                //city = city.stringByReplacingOccurrencesOfString("市", withString: "")
                //State = State.stringByReplacingOccurrencesOfString("省", withString: "")
                
                
                
                //                println(city)
                //            println(country)
                //            println(CountryCode)
                //            println(FormattedAddressLines)
                //            println(Name)
                //                println(State)
                //            println(SubLocality)
            }else {
                //转换失败
            }
        
        })
    }
}
