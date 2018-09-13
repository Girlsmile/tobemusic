//
//  SeclctedListFromSongsController.swift
//  TubeMusic
//
//  Created by 古智鹏 on 2018/8/27.
//  Copyright © 2018年 古智鹏. All rights reserved.
//

import Foundation
import SnapKit
import RealmSwift
import SnapKit
class SeclctedListFromSongsController: UIViewController,UIGestureRecognizerDelegate{
    
    //懒加载tableview
    lazy var  tableViewMain = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height), style: UITableViewStyle.plain)
    
    private  var rootData:[Song]?
    
    var addListName:String = ""
    
    func dataInit() {
        rootData = DAOEngine.showSongInDefault(listName: "default")
    }
    //按钮相关
    var editButton: CustomBtn = CustomBtn(frame: CGRect(x: 300, y: 600, width: 100, height: 100))
    var deleteButton: CustomBtn = CustomBtn(frame: CGRect(x: 0, y: 0, width: 150, height: 50))
    var addToListButton: CustomBtn = CustomBtn(frame: CGRect(x: 204, y: 0, width: 150, height: 50))
    
    //右上角编辑按钮
    let leftBarItem = UIBarButtonItem()
    func UIinit() {
        
        self.view.backgroundColor = UIColor.white
        let btn : CustomBtn = CustomBtn()
        btn.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        btn.setTitle("Done", for: .normal)
        btn.center = view.center
        btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: btn)
        //self.title = "音乐列表"
        self.view.addSubview(tableViewMain)
        //去分割线
        tableViewMain.separatorStyle = UITableViewCellSeparatorStyle.none
        tableViewMain.delegate = self
        tableViewMain.dataSource = self
        //注册cell重用
        tableViewMain.register(PlayerListCell.self , forCellReuseIdentifier: "ID3")
        
        //右上按钮
        let leftBarItem = UIBarButtonItem( title: "Cancle", style: UIBarButtonItemStyle.plain, target: self, action: #selector(editClick))
        self.navigationItem.leftBarButtonItem = leftBarItem
        
        //表格在编辑状态下允许多选
        self.tableViewMain.allowsMultipleSelectionDuringEditing = true
        self.tableViewMain.setEditing(true, animated:true)
        
    }
    
    
    
    override func viewDidLoad() {
        dataInit()
        UIinit()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        dataInit()
        tableViewMain.reloadData()
    }
    
    @objc fileprivate func btnClick(sender:UIButton) {
        var listSong = [Song]()
        var selectedIndexs = [Int]()
        
        if let selectedItems = tableViewMain.indexPathsForSelectedRows {
            for indexPath in selectedItems {
                selectedIndexs.append(indexPath.row)
            }
        }
        
        print("选中项的索引为：", selectedIndexs)
        print("选中项的值为：")
        for index in selectedIndexs {
            print(rootData![index])
            listSong.append(rootData![index])
        }
        //加到播放列表
         DAOEngine.addSongsToList(songs: listSong, listNames:[addListName])
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    
    //编辑按钮相应
    @objc func editClick(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension SeclctedListFromSongsController: UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//            if self.tableViewMain.isEditing == true {
//                let cell = self.tableViewMain.cellForRow(at: indexPath)
//                print(tableViewMain.indexPathsForSelectedRows)
//                print("选中")
//            } else {
//
//            }
    }
}

extension SeclctedListFromSongsController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return rootData!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PlayerListCell = tableView.dequeueReusableCell(withIdentifier: "ID3",for: indexPath) as! PlayerListCell
        cell.getTitle(song: rootData![indexPath.row])
        return cell
    }

}
