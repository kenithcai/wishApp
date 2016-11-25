//
//  SettingViewController.swift
//  HopeApp
//
//  Created by KenithCai on 16/11/7.
//  Copyright © 2016年 KenithCai. All rights reserved.
//

import UIKit
import MessageUI

class SettingViewController: BaseViewController,UITableViewDelegate, UITableViewDataSource,MFMailComposeViewControllerDelegate{

    var m_names:[String] = ["设置","意见反馈","给我打分","分享给朋友","关于"]
    var m_images:[String] = ["btn_set","btn_msg","btn_score","btn_share_set","btn_about"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickCloseBtn(_ sender: UIButton) {
        if (g_closeFunc != nil) {
            g_closeFunc!()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    // 表格数量
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return m_names.count;
    }
    
    // 创建表格
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = UITableViewCell()
        cell.accessoryType = UITableViewCellAccessoryType(rawValue: 1)!
        
        let image = UIImage(named:m_images[indexPath.row])
        cell.imageView?.image = image
        
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.text = m_names[indexPath.row]
        cell.textLabel?.textColor = UIColor.white
        //设置cell的一些属性······
        return cell
    }
    // 点击
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        switch indexPath.row
        {
        case 0:
            print("indexPath.row = \(indexPath.row)")
        case 1:
            self.sendMail()
        case 2:
            self.gotoAppStore()
        case 3:
            print("indexPath.row = \(indexPath.row)")
        case 4:
            print("indexPath.row = \(indexPath.row)")
        default:
            print("indexPath.row = \(indexPath.row)")
        }
    }
    
    // 邮件
    func sendMail()
    {
        //首先要判断设备具不具备发送邮件功能
        if MFMailComposeViewController.canSendMail(){
            let controller = MFMailComposeViewController()
            //设置代理
            controller.mailComposeDelegate = self
            //设置主题
            controller.setSubject("意见反馈")
            //设置收件人
            controller.setToRecipients(["294121600@qq.com"])
            
            //设置邮件正文内容（支持html）
            controller.setMessageBody("我是邮件正文", isHTML: false)
            
            //打开界面
            self.present(controller, animated: true, completion: nil)
        }else{
            print("本设备不能发送邮件")
        }
        
        
    }
    
    //发送邮件代理方法
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?)
    {
        controller.dismiss(animated: true, completion: nil)
        switch result{
        case MFMailComposeResult.sent:
            print("邮件已发送")
        case MFMailComposeResult.cancelled:
            print("邮件已取消")
        case MFMailComposeResult.saved:
            print("邮件已保存")
        case MFMailComposeResult.failed:
            print("邮件发送失败")
        }
    }
    
    // 给我打分
    func gotoAppStore()
    {
        let urlString = "itms-apps://itunes.apple.com/app/id444934666"
        let url = NSURL(string: urlString)
        UIApplication.shared.openURL(url! as URL)
    }
}
