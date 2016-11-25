//
//  ShareViewController.swift
//  HopeApp
//
//  Created by KenithCai on 16/11/7.
//  Copyright © 2016年 KenithCai. All rights reserved.
//

import UIKit

class ShareViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickCloseBtn(_ sender: UIButton) {
        if (g_closeFunc != nil) {
            g_closeFunc!()
        }
//        self.modalTransitionStyle = .crossDissolve
//        UIView.setAnimationTransition
        self.dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
