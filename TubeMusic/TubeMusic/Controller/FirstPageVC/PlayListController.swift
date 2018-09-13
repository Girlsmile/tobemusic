//
//  setController.swift
//  TubeMusic
//
//  Created by 古智鹏 on 2018/7/31.
//  Copyright © 2018年 古智鹏. All rights reserved.
//

import Foundation
import SnapKit
import RealmSwift
import SnapKit
class PlayListController: UIViewController,UIGestureRecognizerDelegate{

    //懒加载tableview
    lazy var  tableViewMain = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height), style: UITableViewStyle.plain)
    
    private  var rootData:Results<SongList>?
    //使用我的的数据库
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
        btn.setTitle("Player", for: .normal)
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
        let leftBarItem = UIBarButtonItem( title: "Edit", style: UIBarButtonItemStyle.plain, target: self, action: #selector(editClick))
        self.navigationItem.leftBarButtonItem = leftBarItem
        
        //表格在编辑状态下允许多选
       //  self.tableViewMain.allowsMultipleSelectionDuringEditing = true
        
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
         self.navigationController?.navigationBar.isTranslucent = false
       
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
        let playingVC =  SharePlayerViewController.getPlayerController()
        self.navigationController?.pushViewController(playingVC, animated: true)
    }
    
  
    
    //编辑按钮相应
    @objc func editClick(sender: UIButton) {
        //在正常状态和编辑状态之间切换
        if(self.tableViewMain.isEditing == false) {
            let leftBarItem = UIBarButtonItem( title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(editClick))
            self.navigationItem.leftBarButtonItem = leftBarItem
            self.tableViewMain.setEditing(true, animated:true)
            
        }
        else {
            self.tableViewMain.setEditing(false, animated:true)
            let leftBarItem = UIBarButtonItem( title: "Edit", style: UIBarButtonItemStyle.plain, target: self, action: #selector(editClick))
            self.navigationItem.leftBarButtonItem = leftBarItem
        }
        
    }
    
}

extension  PlayListController: UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
     if indexPath.section == 0 {
            self.present(alert, animated: true, completion: nil)
        } else if indexPath.section == 1 {
            if self.tableViewMain.isEditing == true {
                let cell = self.tableViewMain.cellForRow(at: indexPath)
                cell?.accessoryType = .detailButton
                print("选中")
            } else {
                let nextPage = DIYSongListController()
                var data:[Song] = []
                for song in rootData![indexPath.row].songs {
                    data.append(song)
                }
                nextPage.rootData = data
                nextPage.currentListName = rootData![indexPath.row].name
                self.navigationController?.pushViewController(nextPage, animated: true)
                
            }
        }
    }
}

extension  PlayListController: UITableViewDataSource {
    
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
            let cell: MusicListCell = tableView.dequeueReusableCell(withIdentifier: "ID3",for: indexPath) as!MusicListCell
            cell.selectionStyle = .none
            cell.getTitle(songList: rootData![indexPath.row])
            let title:Int = DAOEngine.showSong(listName: rootData![indexPath.row].name)
            cell.playlistCount.text = "\(title)" + "  item"
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
