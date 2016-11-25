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
    
    @IBOutlet weak var g_shareBtn: UIButton!
    @IBOutlet weak var g_settingBtn: UIButton!

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    let url = "http://blog.fathoo.xyz/index.php?a=hope&m=getSencence"
    func reloadData()
    {
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

                    // 显示图片
                    self.showImg(picUrl!)
                    
                    // 显示文字
                    self.showLab(content!)
                }
                break
                
            case .failure(_):
                print(response.result.error ?? "出错")
                break
                
            }
        }
    }
    
    func showImg(_ imgUrl:String)
    {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0,y: 0,width: g_screenSize.width,height: g_screenSize.height)
        imageView.contentMode = .scaleAspectFit
        self.view.insertSubview(imageView, at: 0)
        imageView.kf.setImage(with: URL(string: imgUrl)!)
        g_imageView = imageView
    }
    
    func showLab(_ content:String)
    {
        let label=UILabel(frame:CGRect(x: 30, y: 448, width: g_screenSize.width-60, height: 120))
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        self.view.addSubview(label)
        label.text = content
        g_labView = label
    }
    
    // 显示隐藏界面上的东西
    func showInfo(show: Bool)
    {
        g_settingBtn.isHidden = show
        g_shareBtn.isHidden = show
        g_labView?.isHidden = show
        
        let view = g_imageView!.viewWithTag(GaussianBlurTag)
        if (view != nil) {
            view?.removeFromSuperview()
        }
    }
    // 分享
    @IBAction func clickShare(_ sender: UIButton) {
        self.showInfo(show: true)
        
        AppUtil.gaussianBlur(view: g_imageView!)
        AppUtil.addView(vc: self, name: "ShareViewController",closure: {self.showInfo(show: false)})
    }
    // 设置页面
    @IBAction func clickSetting(_ sender: UIButton) {
        self.showInfo(show: true)
        
        AppUtil.gaussianBlur(view: g_imageView!)
        AppUtil.addView(vc: self, name: "SettingViewController",closure: {self.showInfo(show: false)})

    }
}

