//
//  sortList.swift
//  TubeMusic
//
//  Created by 古智鹏 on 2018/8/6.
//  Copyright © 2018年 古智鹏. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SortList: UIViewController{
    
  let data: [SortUrl] = [.Trending,.PopMusic,.HouseMusic,.LatinMusic,.ElectronicMusic,.HipHopMusic,.Reggae,.Trap,.PopRock,.Country,.RwithB,.AsianMusic,.MexicanMusic,.Soul,.RhythmBlues,.ChristianMusic,.HardRock,.HeavyMetal,.ClassicalMusic,.AlternativeRock,.AlternativeRock]
    //懒加载tableview
    private lazy var  tableViewMain = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height), style: UITableViewStyle.plain)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.dataInit()
        self.UIInit()
    }
    
    func dataInit() {
        tableViewMain.delegate = self
        tableViewMain.dataSource = self
        //注册cell重用
        tableViewMain.register(MusicListCell.self , forCellReuseIdentifier: "ID1")
        tableViewMain.register(SortCell.self, forCellReuseIdentifier: "ID2")
    }
    
    func UIInit(){
        self.title = "音乐列表"
        self.view.addSubview(tableViewMain)
        //去分割线
         tableViewMain.separatorStyle = UITableViewCellSeparatorStyle.none
        // weak open var dataSource: UITableViewDataSource?
        //weak open var delegate: UITableViewDelegate? 直接是属性委托
    }
 
    
}

extension  SortList: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
}

extension  SortList: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SortCell = tableView.dequeueReusableCell(withIdentifier: "ID2",for: indexPath) as! SortCell
        //cell取代选中
        cell.selectionStyle = .none
        cell.title(sort: data[indexPath.row])
        //添加tag,设置button的tag 为tableview对应的行
        cell.lableButton.tag = indexPath.row
        //加入button手势事件
        cell.lableButton.addTarget(self, action: #selector(opensort), for: UIControlEvents.touchUpInside)
        return cell
    }
    
    private func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        self.performSegue(withIdentifier: "page1", sender: self)
    }
    
    //点击事件
    @objc func opensort(sender:UIButton) {
        print(sender.tag)
        let nextVC = MusicListController()
        nextVC.title = self.data[sender.tag].rawValue
        nextVC.playListId = self.data[sender.tag].getUrlId()
        
        //显示第二页的控制器
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

