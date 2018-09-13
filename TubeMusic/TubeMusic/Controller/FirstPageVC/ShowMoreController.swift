//
//  showMoreController.swift
//  TubeMusic
//
//  Created by 古智鹏 on 2018/8/1.
//  Copyright © 2018年 古智鹏. All rights reserved.
//

import Foundation
import SnapKit
import RealmSwift
import SnapKit
import  MessageUI

class ShowMoreController: UIViewController,MFMessageComposeViewControllerDelegate{
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
        }
    

    //懒加载tableview
    lazy var  tableViewMain = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height), style: UITableViewStyle.plain)
    
       var rootData:[String] = ["Message","Email","Twitter","Facebook"]
    
    func UIinit() {
        
        self.view.backgroundColor = UIColor.white
        let btn : CustomBtn = CustomBtn()
      
        //self.title = "音乐列表"
        self.view.addSubview(tableViewMain)
        //去分割线
        tableViewMain.separatorStyle = UITableViewCellSeparatorStyle.none
        tableViewMain.delegate = self
        tableViewMain.dataSource = self
        self.navigationController?.navigationBar.isTranslucent = false
    
        
    }
    
    
    
    override func viewDidLoad() {
        UIinit()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableViewMain.reloadData()
    }
    
    
    
    
  
    
}

extension  ShowMoreController: UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
           
            
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                
                //首先要判断设备具不具备发送短信功能
                if MFMessageComposeViewController.canSendText(){
                    let controller = MFMessageComposeViewController()
                    //设置短信内容
                    controller.body = "一款好玩的免费应用分享给你！"
                    //设置收件人列表
                    controller.recipients = []
                    //设置代理
                    controller.messageComposeDelegate = self
                    //打开界面
                    self.present(controller, animated: true, completion: { () -> Void in
                        
                    })
                }
                else{
                    print("本设备不能发送短信")
                }
            }
        }
    }
}

extension  ShowMoreController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return rootData.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let toolCell = UITableViewCell.init(style: .default, reuseIdentifier: "ToolCell")
            toolCell.textLabel?.text = ("SHARE")
            toolCell.textLabel?.textColor = UIColor.gray
            return toolCell
        } else {
            let toolCell = UITableViewCell.init(style: .default, reuseIdentifier: "ToolCell")
            toolCell.textLabel?.text = (rootData[indexPath.row])
            return toolCell
        }
    }
    
}
