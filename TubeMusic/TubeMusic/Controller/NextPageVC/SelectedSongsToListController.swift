//
//  SelectedSongsToList.swift
//  TubeMusic
//
//  Created by 古智鹏 on 2018/8/25.
//  Copyright © 2018年 古智鹏. All rights reserved.
//

import Foundation
import SnapKit
import RealmSwift
import SnapKit
class SelectedSongsToListController: UIViewController,UIGestureRecognizerDelegate{
    
    //懒加载tableview
    lazy var  tableViewMain = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height), style: UITableViewStyle.plain)
    
    private  var rootData:Results<SongList>?
    
    var addSongs:[Song] = []
    
    //使用默认的数据库
    let realm = DAOEngine.realm
    func dataInit() {
        rootData = realm.objects(SongList.self)
    }
    //按钮相关
    var editButton: CustomBtn = CustomBtn(frame: CGRect(x: 300, y: 600, width: 100, height: 100))
    var deleteButton: CustomBtn = CustomBtn(frame: CGRect(x: 0, y: 0, width: 150, height: 50))
    var addToListButton: CustomBtn = CustomBtn(frame: CGRect(x: 204, y: 0, width: 150, height: 50))
    
    //右上角编辑按钮
    let leftBarItem = UIBarButtonItem()
    
    let alert = UIAlertController(title: "", message: "New Playlist", preferredStyle: .alert)
    
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
        tableViewMain.register(MusicListCell.self , forCellReuseIdentifier: "ID3")
        
        //右上按钮
        let leftBarItem = UIBarButtonItem( title: "Cancle", style: UIBarButtonItemStyle.plain, target: self, action: #selector(editClick))
        self.navigationItem.leftBarButtonItem = leftBarItem
        
        //表格在编辑状态下允许多选
         self.tableViewMain.allowsMultipleSelectionDuringEditing = true
         self.tableViewMain.setEditing(true, animated:true)
        
        //弹窗
        alert.addTextField{(usernameText) ->Void in
            usernameText.placeholder = "listName"
        }
        
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        let login = UIAlertAction(title: "OK", style: .default, handler: {
            ACTION in
            let listName = self.alert.textFields?.first?.text
            DAOEngine.addSongListByName(listName!)
            self.tableViewMain.reloadData()
        })
        alert.addAction(cancel)
        alert.addAction(login)
        
        
        
    }
    
    
    
    override func viewDidLoad() {
        dataInit()
        UIinit()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        dataInit()
        tableViewMain.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    @objc fileprivate func btnClick(sender:UIButton) {
        var listNames = [String]()
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
            listNames.append(rootData![index].name)
        }
        //加到播放列表
        DAOEngine.addSongsToList(songs: self.addSongs, listNames: listNames)
        //关闭自己
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    
    //编辑按钮相应
    @objc func editClick(sender: UIButton) {
       self.navigationController?.popViewController(animated: true)
    }
    
}

extension  SelectedSongsToListController: UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            self.present(alert, animated: true, completion: nil)
        } else if indexPath.section == 1 {
            if self.tableViewMain.isEditing == true {
                let cell = self.tableViewMain.cellForRow(at: indexPath)
                print(tableViewMain.indexPathsForSelectedRows)
                print("选中")
            } else {
                
                
                
            }
        }
    }
}

extension  SelectedSongsToListController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return rootData!.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let toolCell = UITableViewCell.init(style: .default, reuseIdentifier: "ToolCell")
            toolCell.imageView?.image = #imageLiteral(resourceName: "Create")
            toolCell.textLabel?.text = ("Create New Playlist...")
            return toolCell
        } else {
            let cell: MusicListCell = tableView.dequeueReusableCell(withIdentifier: "ID3",for: indexPath) as! MusicListCell
            cell.getTitle(songList: rootData![indexPath.row])
            return cell
        }
    }
    
    //可编辑section
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 {
            return false
        } else {
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "点击删除"
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            print("删除")
            DAOEngine.deleteSongListByName(rootData![indexPath.row].name)
            tableViewMain.reloadData()
        }
    }
}
