//
//  playerListController.swift
//  TubeMusic
//
//  Created by 古智鹏 on 2018/8/14.
//  Copyright © 2018年 古智鹏. All rights reserved.
//

import Foundation
import SnapKit
import  Alamofire
import UIKit
class PlayerListController: UIViewController {
    
    //懒加载tableview
    lazy var  tableViewMain = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height), style: UITableViewStyle.plain)
    private lazy var rootData:RootClass = RootClass()
    
    func dataInit() {
        rootData = (RootClass.deserialize(from: (SaveEngine.readDic(name: "utbemusic.plist"))))!
    }
    
    func UIinit() {
        self.view.backgroundColor = UIColor.white
        //self.title = "音乐列表"
        self.view.addSubview(tableViewMain)
        //去分割线
        tableViewMain.separatorStyle = UITableViewCellSeparatorStyle.none
        tableViewMain.delegate = self
        tableViewMain.dataSource = self
        //注册cell重用
        tableViewMain.register(PlayerListCell.self , forCellReuseIdentifier: "ID3")
    }
    
    override func viewDidLoad() {
        dataInit()
        UIinit()
    }
}

extension PlayerListController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let playView =  SharePlayerViewController.getPlayerController()
        playView.openNewVideo(withVideoId: rootData.items[indexPath.row].snippet.resourceId.videoId, videoIndex: indexPath.row, videoList: rootData.items,videoTitle: rootData.items[indexPath.row].snippet.title)
        playView.playingIndex = indexPath.row
        playView.musicTitleLable.text = rootData.items[indexPath.row].snippet.title
        for item in rootData.items {
            playView.videoIds.append(item.snippet.resourceId.videoId)
        }
        self.navigationController?.pushViewController(playView, animated: true)
    }
}

extension PlayerListController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rootData.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //自己写cell 相当于adapter
        let cell: PlayerListCell = tableView.dequeueReusableCell(withIdentifier: "ID3",for: indexPath) as! PlayerListCell
        //cell取代选中
        cell.selectionStyle = .none
        cell.title(item: rootData.items[indexPath.row])
        //添加tag
        // cell.buttonPlay.tag = indexPath.row   //设置button的tag 为tableview对应的行
        //加入button手势事件
        // cell.buttonPlay.addTarget(self, action: #selector(playbutton), for: UIControlEvents.touchUpInside)
        return cell
    }
}
