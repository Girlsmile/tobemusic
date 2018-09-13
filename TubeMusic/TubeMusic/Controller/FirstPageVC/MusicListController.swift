//
//  musicListController.swift
//  TubeMusic
//
//  Created by 古智鹏 on 2018/7/31.
//  Copyright © 2018年 古智鹏. All rights reserved.
//

import Foundation
import SnapKit
import Alamofire
import UIKit
import MJRefresh_Bell
import JGProgressHUD
import RealmSwift
class MusicListController: UIViewController {
    //tableview相关
    private lazy var  tableViewMain = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height), style: UITableViewStyle.plain)
  
    //资源相关
    private lazy var rootData: RootClass = RootClass()
    private lazy var newRootData: RootClass = RootClass()
    
    //请求参数相关
    private var loadTime = 1
    private var MaxResult = 10
    public lazy var playListId = "PLhInz4M-OzRUsuBj8wF6383E7zm2dJfqZ"
    private lazy var  pageToken = ""

    //刷新加载相关
    let hud = JGProgressHUD(style: .dark)
    //跳转逻辑
    var isFirtToShowVideo: Bool = true
    var selected = false
    lazy var isFirstAdd = true
    
    //跳跳图
    var playingId:String?
    var playRate:Float?
    
    override func loadView() {
        super.loadView()
        self.gethttp()
    }
    
    override func viewDidLoad() {
         self.navigationController?.hidesBottomBarWhenPushed = true
        super.viewDidLoad()
        hud.textLabel.text = "Loading"
        hud.show(in: self.view)
        Thread.detachNewThread {
            self.gethttp()
        }
        
        if SharePlayerViewController.isFirstOpen == false {
          SharePlayerViewController.getPlayerController().rhythmViewDelegate = self
        }
     }
    
    override func viewDidAppear(_ animated: Bool) {
        //判断是否选中
        //print("55555555")
        let realmData = DAOEngine.showSongInDefault(listName: "default")
        if rootData.items != nil {
            print("55555555")
            for  item  in self.rootData.items {
                for realmItem in realmData {
                    if item.snippet.resourceId.videoId == realmItem.songVideoId {
                        item.isselsected = true
                        break
                    } else {
                        item.isselsected = false
                    }
                }
            }
        }
        
        if SharePlayerViewController.isFirstOpen == false {
            SharePlayerViewController.getPlayerController().rhythmViewDelegate = self
        }
       tableViewMain.reloadData()
        
      
    }
    
     func gethttp() {
        let url2 = "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&pageToken=\(pageToken)&maxResults=\(MaxResult)&playlistId=\(playListId)&key=AIzaSyBmdMSmg08SxfaucrZ45-B0CtxwPSg_vPA"
        HttpEngine.shareInstance.getRequest(url: url2,parameters: nil,
             success: { (jsonDic) in
             self.updateUI(jsonDic: jsonDic)
         },
             failure:{ (error) in
             print(error)
         }
       )
    }
    

    func updateUI(jsonDic:NSDictionary) {
        
        //存到modle
        if let modle:RootClass = RootClass.deserialize(from: jsonDic) {
            self.newRootData = modle
            if self.loadTime == 1 {
               self.rootData = modle
            } else {
                for item in modle.items {
                    self.rootData.items.append(item)
                }
            }
            
            //判断是否选中
            let realmData = DAOEngine.showSongInDefault(listName: "default")
            if rootData.items != nil {
                for  item  in self.rootData.items {
                    for realmItem in realmData {
                        if item.snippet.resourceId.videoId == realmItem.songVideoId {
                            item.isselsected = true
                            break
                        } else {
                            item.isselsected = false
                        }
                    }
                }
            }
            
            DispatchQueue.main.async(execute: {
                self.dataInit()
                self.UIInit()
                self.hud.dismiss()
                self.tableViewMain.reloadData()
            })
        }
    }
    
    func dataInit() {
      
     //rootdata=(RootClass.deserialize(from: (StorelnPlist.readDic(name: "utbemusic.plist"))))!
    }
    
    func UIInit(){
        self.view.backgroundColor = UIColor.white
        //播放器按钮
        let btn : CustomBtn = CustomBtn()
        btn.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        btn.setTitle("Player", for: .normal)
        btn.center = view.center
        btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: btn)
        //列表按钮
        let leftBarItem = UIBarButtonItem( title: "Categories", style: UIBarButtonItemStyle.plain, target: self, action: #selector(listAllSorts))
        self.navigationItem.leftBarButtonItem = leftBarItem
        self.navigationController?.navigationBar.isTranslucent = false
       
        //self.title = "音乐列表"
        self.view.addSubview(tableViewMain)
        
        //去分割线
         tableViewMain.separatorStyle = UITableViewCellSeparatorStyle.none
        // weak open var dataSource: UITableViewDataSource?
        //weak open var delegate: UITableViewDelegate? 直接是属性委托
        tableViewMain.delegate = self
        tableViewMain.dataSource = self
        //注册cell重用
        tableViewMain.register(MusicListCell.self , forCellReuseIdentifier: "ID1")
//        self.tableViewMain.mj_header = MJRefreshNormalHeader(
//            refreshingBlock: {
//            self.tableViewMain.mj_header.endRefreshing()
//            }
//        )
        self.tableViewMain.mj_footer = MJRefreshBackGifFooter (
            refreshingBlock: {
            print("下拉刷新")
            self.pageToken = self.newRootData.nextPageToken
            self.loadTime = 2
            Thread.detachNewThread {
                self.gethttp()
            }
            self.tableViewMain.mj_footer.endRefreshing()
            }
        )
        
    }
    
    @objc func listAllSorts() {
        let nextVC = SortList()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc fileprivate func btnClick(sender:UIButton) {
         self.navigationController?.hidesBottomBarWhenPushed = true
        let playingVC =  SharePlayerViewController.getPlayerController()
        self.navigationController?.pushViewController(playingVC, animated: true)
    }
    
    @objc func playbutton(sender:UIButton) {
        let play = PlayerController()
        self.navigationController?.pushViewController(play, animated: true)
    }
}

extension MusicListController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if rootData.kind != nil {
            
        
        let cell:MusicListCell = tableView.dequeueReusableCell(withIdentifier: "ID1",for: indexPath) as! MusicListCell
        cell.getTitle(item: rootData.items[indexPath.row])
        //添加tag
        // cell.buttonPlay.tag = indexPath.row   //设置button的tag 为tableview对应的行
        //加入button手势事件
        // cell.buttonPlay.addTarget(self, action: #selector(playbutton), for: UIControlEvents.touchUpInside)
        cell.selectionIcon.tag = indexPath.row
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(updateSelectionIcon))
        cell.selectionIcon.addGestureRecognizer(singleTapGesture)
        cell.selectionIcon.isUserInteractionEnabled = true
        
        if playingId != nil && self.playRate != nil {
            
            if rootData.items[indexPath.row].snippet.resourceId.videoId! == self.playingId {
                print("1113313",indexPath.row)
               cell.rhythmView?.isHidden = false
                if self.playRate == 1 {
                    cell.rhythmView?.startAnimating()
                } else {
                    cell.rhythmView?.stopAnimating()
                }
            } else {
                cell.rhythmView?.isHidden = true
            }
        }
        return cell
        } else {
            let toolCell = UITableViewCell.init(style: .default, reuseIdentifier: "ToolCell")
            toolCell.textLabel?.text = ("No data")
            toolCell.textLabel?.textColor = UIColor.gray
            return toolCell
        }
    }
    
    
    private func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath){
        self.performSegue(withIdentifier: "page1", sender: self)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if rootData.kind != nil {
        
        if SharePlayerViewController.isFirstOpen {
            let playView = PlayerController()
            playView.videoId = rootData.items[indexPath.row].snippet.resourceId.videoId
            playView.playingIndex = indexPath.row
            playView.musicTitleLable.text=rootData.items[indexPath.row].snippet.title
            for item in rootData.items{
                playView.videoIds.append(item.snippet.resourceId.videoId)
            }
            playView.PlaySongs = Util.RootClassToSongs(modle: rootData.items)
            self.navigationController?.pushViewController(playView, animated: true)
            SharePlayerViewController.isFirstOpen = false
        }  else {
            let playView = SharePlayerViewController.getPlayerController()
            playView.openNewVideo(withVideoId: rootData.items[indexPath.row].snippet.resourceId.videoId, videoIndex: indexPath.row, videoList: rootData.items,videoTitle: rootData.items[indexPath.row].snippet.title)
            self.navigationController?.pushViewController(playView, animated: true)
        }
      }
    }
    
    @objc func updateSelectionIcon(selectionIcon: UITapGestureRecognizer) {
            addToSongs((selectionIcon.view?.tag)!)
            self.rootData.items[(selectionIcon.view?.tag)!].isselsected = true
            tableViewMain.reloadData()
    }
    
    //加到Songs相关
    func addToSongs(_ tag: Int) {
       print(tag)
       let currentItem = rootData.items[tag]
       //创建插入记录
       let currentSong = Song()
       currentSong.songPhotoUrl = currentItem.snippet.thumbnails.defaultField.url
       currentSong.songTitle = currentItem.snippet.title
       currentSong.songVideoId = currentItem.snippet.resourceId.videoId
       currentSong.songDuration = "5:34"
       // 数据持久化操作（类型记录也会自动添加的）
       DAOEngine.addSong(song: currentSong,listName: "default")
    }
}

extension MusicListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if rootData.kind != nil  {
            return rootData.items.count
        } else {
            return 1
        }
  
    }
}

// MARK: - <#RhythmViewDelegate#>
extension MusicListController: RhythmViewDelegate {
  
    func showRhythmState(id: String, playRate: Float) {
         self.playRate = playRate
         self.playingId = id
    }

}


