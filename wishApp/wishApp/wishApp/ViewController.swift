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
    
    func showImg(imgUrl:String)
    {
        let imageView = UIImageView()
        imageView.frame = CGRectMake(0,0,g_screenSize.width,g_screenSize.height)
        imageView.contentMode = .ScaleAspectFit
        self.view.insertSubview(imageView, atIndex: 0)
        
        imageView.kf_setImageWithURL(NSURL(string: imgUrl)!)
        
    }
    
    func showLab(content:String)
    {
        let label=UILabel(frame:CGRectMake(0, 448, g_screenSize.width, 120))
        label.lineBreakMode = .ByWordWrapping
        label.numberOfLines = 0
        self.view.addSubview(label)
        
        
        label.text = content
    }
    @IBAction func clickBtn(sender: UIButton) {
        print("aaaaa btn")
    }
    @IBOutlet weak var aaaa: UIButton!

    @IBAction func clickSetOut(sender: AnyObject) {
        
        name {$0 * $1}
    }
    
    func name(operation:(Double,Double) -> Double) {
        let b = operation(1.0,2.0)
        print("aaaa = : \(b)")
    }
    @IBAction func clickList(sender: UIButton) {
        print("clickList")
    }
    @IBAction func clickShare(sender: UIButton) {
        print("clickShare")
        //self.performSegueWithIdentifier("EasyCode", sender: self)
    }
}

