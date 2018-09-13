//
//  selfController.swift
//  TubeMusic
//
//  Created by 古智鹏 on 2018/7/31.
//  Copyright © 2018年 古智鹏. All rights reserved.
//

import UIKit
import MJRefresh_Bell
class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    //资源相关
    private lazy var rootData: RootClass = RootClass()
    private lazy var newRootData: RootClass = RootClass()
    
    //请求参数相关
    private var maxResult = 12
    var queryText = ""
    private var loadTime = 1
    public lazy var playListId = "PLhInz4M-OzRUsuBj8wF6383E7zm2dJfqZ"
    private lazy var  pageToken = ""
    
    //请求逻辑相关
    var isSearch = false//默认在非搜索状态下
    
    //播放器按钮
    lazy var btn : CustomBtn = {
        let btn1 = CustomBtn()
        btn1.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        btn1.setTitle("Player", for: .normal)
        btn1.center = view.center
        btn1.addTarget(self, action: #selector(playerClick), for: .touchUpInside)
        return btn1
    }()
    
    //使用懒加载方式来创建UITableView
    lazy var tableView: UITableView = {
        let tempTableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height), style: UITableViewStyle.plain)
        tempTableView.separatorStyle = .none
        tempTableView.delegate = self
        tempTableView.dataSource = self
        tempTableView.tableFooterView = UIView.init()
        tempTableView.mj_header = MJRefreshNormalHeader(
            refreshingBlock: {
                print("上拉刷新")
                sleep(1)
                self.tableView.mj_header.endRefreshing()
        }
        )
        //下拉加载更多
       tempTableView.mj_footer = MJRefreshBackGifFooter (
            refreshingBlock: {
                print("下拉刷新")
                // tempTableView.mj_footer.se
                if self.newRootData.nextPageToken == nil {
                   self.tableView.mj_footer.endRefreshingWithNoMoreData()
                } else {
                     self.pageToken = self.newRootData.nextPageToken
                    self.loadTime = 2
                    Thread.detachNewThread {
                        self.gethttp()
                    }
                }
                
                self.tableView.mj_footer.endRefreshing()
        }
        )
        return tempTableView
    }()
    
    //使用懒加载方式来创建UISearchBar
    lazy var searchBar: UISearchBar = {
        let tempSearchBar = UISearchBar(frame:CGRect(x: 0, y: 64, width: self.view.bounds.size.width, height: 40))
        tempSearchBar.placeholder = "search"
        tempSearchBar.showsCancelButton = true   
        tempSearchBar.delegate = self
        return tempSearchBar
    }()

    
    func dataInit() {}
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(MusicListCell.self , forCellReuseIdentifier: "musicListCell")
        self.tableView.tableHeaderView = self.searchBar
//        self.searchBar.showsBookmarkButton = true
//        self.searchBar.showsSearchResultsButton = true
//        self.searchBar.showsScopeBar = true
         setupUI()
    }
    
    //MARK: UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if rootData.items == nil {
            return 0
        } else {
            return rootData.items.count
        }
      
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MusicListCell = tableView.dequeueReusableCell(withIdentifier: "musicListCell",for: indexPath) as! MusicListCell
        if rootData.items == nil {
            cell.contentView.isHidden = true
            return cell
        } else {
            cell.contentView.isHidden = false
            cell.getSearchTitle(item: rootData.items[indexPath.row])
            cell.selectionIcon.tag = indexPath.row
            let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(updateSelectionIcon))
            cell.selectionIcon.addGestureRecognizer(singleTapGesture)
            cell.selectionIcon.isUserInteractionEnabled = true
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if SharePlayerViewController.isFirstOpen {
            let playView = PlayerController()
            playView.videoId = rootData.items[indexPath.row].id.videoId
            playView.playingIndex = indexPath.row
            playView.musicTitleLable.text=rootData.items[indexPath.row].snippet.title
            for item in rootData.items{
                playView.videoIds.append(item.id.videoId)
            }
            playView.PlaySongs = Util.RootClassToSongsBySearch(modle: rootData.items)
            self.navigationController?.pushViewController(playView, animated: true)
            SharePlayerViewController.isFirstOpen = false
        }  else {
            let playView = SharePlayerViewController.getPlayerController()
            playView.openNewSearchVideo(withVideoId: rootData.items[indexPath.row].id.videoId, videoIndex: indexPath.row, videoList: rootData.items,videoTitle: rootData.items[indexPath.row].snippet.title)
            self.navigationController?.pushViewController(playView, animated: true)
        }
    }
    
}

// MARK: - UISearchDelegate
extension SearchViewController: UISearchBarDelegate {
    //MARK: UISearchBarDelegate
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print(#function)
        isSearch = false
        searchBar.resignFirstResponder()
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            print(#function)
            self.rootData = RootClass()
            loadTime = 1
            Thread.detachNewThread {
                self.gethttp()
            }
            isSearch = false
            searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(#function)
        isSearch = false
//        searchText.data(using: .utf8)
//        self.queryText = NSString(data:  searchText.data(using: .utf8)!, encoding: )
        self.queryText =  searchText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
    }
}


// MARK: - ButtonEvent
extension SearchViewController {
    
    @objc func  playerClick(sender: UIButton) {
        let playingVC =  SharePlayerViewController.getPlayerController()
        self.navigationController?.pushViewController(playingVC, animated: true)
    }
    
    @objc func updateSelectionIcon(selectionIcon: UITapGestureRecognizer) {
        addToSongs((selectionIcon.view?.tag)!)
        self.rootData.items[(selectionIcon.view?.tag)!].isselsected = true
        tableView.reloadData()
    }
    //加到Songs相关
    func addToSongs(_ tag: Int) {
        print(tag)
        let currentItem = rootData.items[tag]
        //创建插入记录
        let currentSong = Song()
        currentSong.songPhotoUrl = currentItem.snippet.thumbnails.defaultField.url
        currentSong.songTitle = currentItem.snippet.title
        currentSong.songVideoId = currentItem.id.videoId
        currentSong.songDuration = "5:34"
        print(currentSong.songTitle)
        // 数据持久化操作（类型记录也会自动添加的）
        DAOEngine.addSong(song: currentSong,listName: "default")
    }
}

// MARK: - UI
private extension SearchViewController {
    func setupUI() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: btn)
        self.view.addSubview(tableView)
         self.navigationController?.navigationBar.isTranslucent = false
        setUpConstraints()
    }
    
    func setUpConstraints() {
        
    }
}

// MARK: - NetWork
extension SearchViewController {
    func gethttp() {
        print("httpget",#function)
        let url2:String = "https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=\(maxResult)&q=\(queryText)&pageToken=\(pageToken)&type=video&videoDuration=any&videoCategoryId=10&key=AIzaSyCei_yAm8wT8KyMlC1BLoW1Ip2Wxd48k_g"
        HttpEngine.shareInstance.getRequest(url: url2,parameters: nil,
          success: { (jsonDic) in
          self.updateUI(jsonDic: jsonDic)
        },
          failure:{ (error) in
          print(error)
          print("错误")
        }
        )
    }
    
    
    func updateUI(jsonDic:NSDictionary) {
        //存到modle
        print("加载数外面",loadTime)
        if let modle:RootClass = RootClass.deserialize(from: jsonDic) {
            print("加载数里面",loadTime)
            self.newRootData = RootClass()
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
                        if item.id.videoId == realmItem.songVideoId {
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
                //                self.UIInit()
                //                self.hud.dismiss()
                self.tableView.reloadData()
            })
        }
    }
}


