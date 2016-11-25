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
    
    // 截屏
    class func imageFromView (view:UIView)->UIImage
    {
        UIGraphicsBeginImageContext(view.frame.size)
        let context = UIGraphicsGetCurrentContext()
        view.layer.render(in: context!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndPDFContext()
//        UIImageWriteToSavedPhotosAlbum(img!, nil, nil, nil);
        return img!
    }
    
    class func screenShots()->UIImage
    {
        let imageSize = UIScreen.main.bounds.size;
       
        UIGraphicsBeginImageContext(imageSize);
        
        let context = UIGraphicsGetCurrentContext();
        for win in UIApplication.shared.windows {
//            if win.responds(to: nil) || win.screen == UIScreen.main {
                context!.saveGState();
                context!.translateBy(x: win.center.x, y: win.center.y);
                context!.concatenate(win.transform);
                context!.translateBy(x: win.bounds.size.width*win.layer.anchorPoint.x, y: -win.bounds.size.height*win.layer.anchorPoint.y);
                win.layer.render(in: context!)
                context!.restoreGState();
//            }
        }
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil);
        return image!
    }
}
  
