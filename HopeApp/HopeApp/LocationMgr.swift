//
//  LocationMgr.swift
//  LocationMgr
//
//  Created by lengshengren on 16/4/4.
//  Copyright © 2016年 Rnning. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
public enum LocationServiceStatus :Int {
    case available
    case undetermined
    case denied
    case restricted
    case disabled
}

public typealias userCLLocation = ((_ location: CLLocation?) -> Void)
public typealias cityString = ((_ city: String? ) -> Void)

private let DistanceAndSpeedCalculationInterval = 5.0;
private let locationMgrInstance = LocationMgr()

open class LocationMgr: NSObject,CLLocationManagerDelegate{
    //创建一个单例
    open class var instance:LocationMgr{
       return locationMgrInstance
    }
    open var userLocation: CLLocation?
    
    //定义闭包变量
    fileprivate var onUserCLLocation: userCLLocation?
    fileprivate var onCityString:cityString?
    //上一次定位时间
    open var LastDistanceAndSpeedCalculation:Double = 0
    //获取定位状态
    class var status:LocationServiceStatus {
        if !CLLocationManager.locationServicesEnabled(){
            return .disabled //请到设置里开启定位服务
        }else{
            switch CLLocationManager.authorizationStatus(){
            case .notDetermined:
                return .undetermined //用户还没有做选择
            case .denied:
                 return .denied      //用户拒绝授权
            case .restricted:
                 return .restricted  //应用拒接使用定位服务
            case .authorizedAlways, .authorizedWhenInUse:
                return .available  //始终授权位置服务 和当使用App时候授权位置服务
            }
            
        }
    }
    
    
    //创建一个 CLLocationManager 对象
    fileprivate var m_locationMgr:CLLocationManager!
    
    //初始化 CLLocationManager
    override fileprivate init() {
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
        startLocation()
    }
    
    //开始定位
    open func startLocation()  {
        m_locationMgr.startUpdatingLocation()
      }
    
    //停止定位
    open func stopLocation()  {
        m_locationMgr.stopUpdatingLocation()
    }
    
    //MARK:- locationManager Delegate
    open func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("定位发生异常:\(NSError.description())")
    }
    
    open func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard locations.count > 0 else{
            return
        }
   
        //过滤连续定位问题
        if LastDistanceAndSpeedCalculation > 0 {
            guard Date .timeIntervalSinceReferenceDate - LastDistanceAndSpeedCalculation  > DistanceAndSpeedCalculationInterval else{
                
                return;
            }
        }

        LastDistanceAndSpeedCalculation = Date.timeIntervalSinceReferenceDate
        let location = CLLocation(latitude: locations.last!.coordinate.latitude, longitude: locations.last!.coordinate.longitude)
//        print(location.coordinate.latitude)
//        print(location.coordinate.longitude)
        userLocation = location
        
        if nil != onUserCLLocation
        {
            onUserCLLocation!(userLocation)
        }
        
        reverseGeocode(location)
    }
    
    
    func reverseGeocode(_ currLocation: CLLocation!) {
        let geocoder = CLGeocoder()
        var placemark:CLPlacemark?
        geocoder.reverseGeocodeLocation(currLocation, completionHandler: { (placemarks, error) -> Void in
            if error != nil {
                print("reverse geodcode fail: \(error!.localizedDescription)")
                return
            }
            let pm = placemarks! as [CLPlacemark]
            if (pm.count > 0){
                placemark = placemarks![0]
                let city:String = placemark!.locality! as String
                if nil != self.onCityString
                {
                    self.onCityString!(city)
                }
                
                self.stopLocation()
            }else{
                print("No Placemarks!")
            }
        })
    }
    
    
//    使用例子
//    LocationMgr.instance.info({ (location) in
//    
//    print(location?.coordinate.latitude)
//    print(location?.coordinate.longitude)
//    
//    }) { (city) in
//    print(city)
//    print(city?.transformToPinYin())
//    }
//    
//    
//    LocationMgr.instance.point { (location) in
//    print(location?.coordinate.latitude)
//    print(location?.coordinate.longitude)
//    }
    
    //获取经纬度和城市
    func info(_ cllocation:@escaping userCLLocation,city:@escaping cityString) -> Void {
        startLocation()
        onUserCLLocation = cllocation;
        onCityString = city;
    }
    //获取城市
    func city(_ city:@escaping cityString) -> Void {
        if AppUtil.simulator() {
            city("广州")
        }
        else
        {
            startLocation()
            onCityString = city;
        }
        
    }
    
    //获取经纬度
    func point(_ cllocation:@escaping userCLLocation) -> Void {
        startLocation()
        onUserCLLocation = cllocation;
    }
   

}



