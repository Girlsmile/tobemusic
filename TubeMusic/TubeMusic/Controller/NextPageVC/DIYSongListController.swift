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
class DIYSongListController: UIViewController,UIGestureRecognizerDelegate{
    
    //懒加载tableview
    lazy var  tableViewMain = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height), style: UITableViewStyle.plain)
    
    var rootData:[Song] = []
    var currentListName: String = ""
    
    override func viewDidDisappear(_ animated: Bool) {
         rootData = DAOEngine.showSong(listName: currentListName)
         tableViewMain.reloadData()
    }
    func dataInit() {
        rootData = DAOEngine.showSong(listName: currentListName)
        //tableViewMain.reloadData()
    }
    //按钮相关
    var editButton: CustomBtn = CustomBtn()
    var deleteButton: CustomBtn = CustomBtn(frame: CGRect(x: 0, y: 0, width: 150, height: 50))
    var addToListButton: CustomBtn = CustomBtn(frame: CGRect(x: 204, y: 0, width: 150, height: 50))
    
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
        tableViewMain.register(PlayerListCell.self , forCellReuseIdentifier: "ID3")
        
        //表格在编辑状态下允许多选
        self.tableViewMain.allowsMultipleSelectionDuringEditing = true
        
        let longPress = UILongPressGestureRecognizer.init(target: self, action: #selector(longPressAction))
        longPress.delegate = self
        longPress.minimumPressDuration = 1
        tableViewMain .addGestureRecognizer(longPress)
        //editButton
        editButton.setImage(#imageLiteral(resourceName: "Edit"), for: .normal)
        editButton.addTarget(self, action: #selector(editClick), for: UIControlEvents.touchUpInside)
        self.view.addSubview(editButton)
        editButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-self.view.center.y/3)
            make.right.equalToSuperview().offset(-30)
        }
        //toorBar按钮
        self.navigationController?.toolbar.backgroundColor = UIColor.orange
        deleteButton.setImage(#imageLiteral(resourceName: "Trash"), for: UIControlState.normal)
        deleteButton.setTitle("Delete", for: UIControlState.normal)
        deleteButton.addTarget(self, action: #selector(deleteButtonClick), for: UIControlEvents.touchUpInside)
        
        addToListButton.setImage(#imageLiteral(resourceName: "Add"), for: .normal)
        addToListButton.setTitle("Add songs", for: .normal)
        addToListButton.addTarget(self, action: #selector(addToListButtonClick), for: UIControlEvents.touchUpInside)
        
        let leftUIBtnItem: UIBarButtonItem = UIBarButtonItem(customView: deleteButton)
        let rightUIBtnItem: UIBarButtonItem = UIBarButtonItem(customView: addToListButton)
        self.setToolbarItems([leftUIBtnItem,rightUIBtnItem], animated: true)
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
        if(self.tableViewMain.isEditing == true) {
            self.tableViewMain.setEditing(false, animated:true)
            self.navigationController?.setToolbarHidden(true, animated: true)
        }
    }
    
    @objc fileprivate func btnClick(sender:UIButton) {
        let playingVC =  SharePlayerViewController.getPlayerController()
        self.navigationController?.pushViewController(playingVC, animated: true)
    }
    
    //单元格长按事件响应
    @objc func longPressAction(gestureRecognizer:UILongPressGestureRecognizer)
    {
        if (gestureRecognizer.state == UIGestureRecognizerState.ended)
        {
            print("UIGestureRecognizerStateEnded");
            //在正常状态和编辑状态之间切换
            if(self.tableViewMain.isEditing == false) {
                self.tableViewMain.setEditing(true, animated:true)
            }
            else {
                self.tableViewMain.setEditing(false, animated:true)
            }
        }
    }
    
    //编辑按钮相应
    @objc func editClick(sender: UIButton) {
        //在正常状态和编辑状态之间切换
        if(self.tableViewMain.isEditing == false) {
            self.tableViewMain.setEditing(true, animated:true)
            self.navigationController?.setToolbarHidden(false, animated: true)
        }
        else {
            self.tableViewMain.setEditing(false, animated:true)
            self.navigationController?.setToolbarHidden(true, animated: true)
        }
        
    }
    
    //删除按钮
    @objc func deleteButtonClick() {
        var deSongs = [Song]()
        var selectedIndexs = [Int]()
        
        if let selectedItems = tableViewMain.indexPathsForSelectedRows {
            for indexPath in selectedItems {
                selectedIndexs.append(indexPath.row)
            }
        }
        
        print("选中项的索引为：", selectedIndexs)
        print("选中项的值为：")
        for index in selectedIndexs {
            print(rootData[index])
            deSongs.append(rootData[index])
        }
        DAOEngine.deleteSongs(bySong: deSongs, mlistName: currentListName)
        rootData = DAOEngine.showSong(listName: currentListName)
        tableViewMain.reloadData()
    }
    
    //加到播放列表按钮
    @objc func addToListButtonClick() {
        var addSongs = [Song]()
        var selectedIndexs = [Int]()
        
        if let selectedItems = tableViewMain.indexPathsForSelectedRows {
            for indexPath in selectedItems {
                selectedIndexs.append(indexPath.row)
            }
        }
        
        print("选中项的索引为：", selectedIndexs)
        print("选中项的值为：")
        for index in selectedIndexs {
            print(rootData[index])
            addSongs.append(rootData[index])
        }
        let nextPage: SeclctedListFromSongsController = SeclctedListFromSongsController()
        nextPage.addListName = currentListName
        self.navigationController?.pushViewController(nextPage, animated: true)
    }
}

extension DIYSongListController: UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            print("随机按钮")
        } else if indexPath.section == 1 {
            if self.tableViewMain.isEditing == true {
               // let cell = self.tableViewMain.cellForRow(at: indexPath)
                print("选中")
            } else {
                
                if SharePlayerViewController.isFirstOpen {
                    let playView = PlayerController()
                    playView.videoId = rootData[indexPath.row].songVideoId
                    playView.playingIndex = indexPath.row
                    playView.musicTitleLable.text=rootData[indexPath.row].songTitle
                    for item in rootData {
                        playView.videoIds.append(item.songVideoId)
                    }
                    print("第二个界面的数据",playView.videoIds)
                    playView.PlaySongs = self.rootData
                    self.navigationController?.pushViewController(playView, animated: true)
                    SharePlayerViewController.isFirstOpen = false
                }  else {
                    let playview = SharePlayerViewController.getPlayerController()
                    playview.openNewVideo(withVideoId: rootData[indexPath.row].songVideoId, videoIndex: indexPath.row, videoList: rootData, videoTitle: rootData[indexPath.row].songTitle)
                    self.navigationController?.pushViewController(playview, animated: true)
                }
            }
        }
    }
}

extension DIYSongListController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return rootData.count
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
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let toolCell = UITableViewCell.init(style: .default, reuseIdentifier: "ToolCell")
            toolCell.imageView?.image=#imageLiteral(resourceName: "Shuffle")
            toolCell.textLabel?.text = ("Shuffle")
            return toolCell
        } else {
            let cell: PlayerListCell = tableView.dequeueReusableCell(withIdentifier: "ID3",for: indexPath) as! PlayerListCell
            cell.getTitle(song: rootData[indexPath.row])
            return cell
        }
    }
}


