//
//  BaseViewController.swift
//  HopeApp
//
//  Created by KenithCai on 16/11/18.
//  Copyright © 2016年 KenithCai. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    public var g_closeFunc:AppUtil.FuncBlock?=nil
    
    public func setClosure(closure:@escaping AppUtil.FuncBlock)
    {
        g_closeFunc = closure
    }
}
