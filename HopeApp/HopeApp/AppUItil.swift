//
//  AppUItil.swift
//  HopeApp
//
//  Created by KenithCai on 16/11/17.
//  Copyright © 2016年 KenithCai. All rights reserved.
//

import Foundation
import UIKit

let GaussianBlurTag = 1000

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
    
}
  
