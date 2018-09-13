//
//  timerChangeController.swift
//  TubeMusic
//
//  Created by 古智鹏 on 2018/8/15.
//  Copyright © 2018年 古智鹏. All rights reserved.
//

import Foundation
import SnapKit
import  Alamofire
import UIKit
class TimerChangeController : UIViewController {
    //懒加载tableview
    private lazy var  tableViewMain = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height), style: UITableViewStyle.plain)
    private lazy var rootData:[Int] = [10,20,30,60,90]
  
    override func viewDidLoad() {
        UIinit()
    }
    
    func UIinit() {
        //self.title = "音乐列表"
        self.view.addSubview(tableViewMain)
        //去分割线
        // tableViewMain.separatorStyle = UITableViewCellSeparatorStyle.none
        tableViewMain.delegate = self
        tableViewMain.dataSource = self
        //注册cell重用
        tableViewMain.register(TimerCell.self, forCellReuseIdentifier: "ID4")
    }
}

extension TimerChangeController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rootData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //自己写cell 相当于adapter
        let cell:TimerCell = tableView.dequeueReusableCell(withIdentifier: "ID4",for: indexPath) as! TimerCell
        //cell取代选中
        cell.selectionStyle = .none
        cell.title(num: rootData[indexPath.row])
        return cell
    }
}

extension TimerChangeController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        let nextVC = getPlayer.getPlayerController()
        //   self.cellClickDelegate=nextVC
        //       nextVC.timerBtnClick(message: rootdata[indexPath.row])
    }
}

