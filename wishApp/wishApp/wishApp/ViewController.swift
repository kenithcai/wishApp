//
//  ViewController.swift
//  wishApp
//
//  Created by KenithCai on 16/9/28.
//  Copyright © 2016年 KenithCai. All rights reserved.
//

import UIKit
import Kingfisher
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //网络请求
        self .reloadData()
    }
    var g_screenSize:CGRect = UIScreen.mainScreen().bounds
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    let url = "http://blog.fathoo.xyz/index.php?a=hope&m=getSencence"
    func reloadData()
    {
        Alamofire.request(.POST, url, parameters: nil)
            .responseJSON { (response) in
                print("jsonRequest:\(response.result)")
                
                if let json = response.result.value
                {
                    print("JSON: \(json)")
                    let content = json["content"]
                    let picUrl = json["picture"]
                    let time = json["release_date"]
                    print("content:\(content), pic:\(picUrl),time:\(time)")
                    
                    // 显示图片
                    self.showImg(picUrl as! String)
                    
                    // 显示文字
                    self.showLab(content as! String)
                }
        }
    }
    
    func showImg(url:String)
    {
        print("size = \(g_screenSize)")
        let imgUrl = "http://blog.fathoo.xyz/png/ppp.jpeg"
        let imageView = UIImageView()
        imageView.kf_setImageWithURL(NSURL(string: imgUrl)!)
        
        imageView.frame = CGRectMake(0,0,g_screenSize.width,g_screenSize.height)
        imageView.contentMode = .ScaleAspectFit
        
        self.view.addSubview(imageView)

    }
    
    func showLab(content:String)
    {
        let label=UILabel(frame:CGRectMake(0, 448, g_screenSize.width, 120))
        label.lineBreakMode = .ByWordWrapping
        label.numberOfLines = 0
        label.text = content
        self.view.addSubview(label)
    }
}

