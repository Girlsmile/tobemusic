
//
//  playerController.swift
//  TubeMusic
//
//  Created by 古智鹏 on 2018/7/31.
//  Copyright © 2018年 古智鹏. All rights reserved.
//

import Foundation
import SnapKit
import AVKit
import YouTubePlayer
import XCDYouTubeKit
import EFAutoScrollLabel
import JGProgressHUD
import RealmSwift
import MediaPlayer
import SDWebImage
import MediaPlayer
class PlayerController:UIViewController {
    
    //部件相关
    //var playUIview:UIView = UIView()
    var labelPlayer:UILabel = UILabel(frame: CGRect(x: 100, y: 100, width: 150, height: 150))
    var playButton: UIButton = UIButton()
    var prevButton: UIButton = UIButton()
    var nextButton: UIButton = UIButton()
    var currentTimeButton: UIButton = UIButton()
    var durationButton: UIButton = UIButton()
    var timeLabel:UILabel = UILabel()
    var timetotalLabel:UILabel = UILabel()
    var playingModeButton:UIButton = UIButton()
    var shuffleModeButton:UIButton = UIButton()
    var musicTitleLable:EFAutoScrollLabel = EFAutoScrollLabel()
    var sleepTimerButton:CustomBtn = CustomBtn()
    var timerView:UIView = UIView()
    lazy var maxVolume: UIImageView =  {
        var imageView = UIImageView()
        imageView.image = UIImage.init(named:"MaxVolume")
        return imageView
        }()
    lazy var minVolume:UIImageView =  {
        var imageView = UIImageView()
        imageView.image = UIImage.init(named:"MinVolume")
        return imageView
    }()
    
    //刷新loading
    let hud = JGProgressHUD(style: .dark)
    
    //进度条相关
    var slider: UISlider = UISlider()
    var playTime: UILabel = UILabel()
    var totaltime = ""
    var sliding = false
    
    //计算相关
    var link: CADisplayLink!
    var playingitem: AVPlayerItem!
    
    //xcd
    var clint = XCDYouTubeClient.default()
    var musicUrl: URL?
    
    //播放器相关
    var playerItem: AVPlayerItem!
    var avplayer: AVPlayer = AVPlayer()
    var playerLayer: AVPlayerLayer!
    var playUIview: videoForLayer = videoForLayer()
    var changeUrl: URL!
    
    //播放列表相关
    //var MyplayingList=playingList.getList()
    //var queuePlayer:AVQueuePlayer!
    var videoId: String = ""
    var videoIds: [String] = [""]
    var shuffleVideoIds: [String] = [""]
    var originalVideoIds: [String] = [""]
    var playingIndex: Int = 0
    var videoUrl: URL?
    var videoUrls: [URL] = []
    
    //播放模式相关
    var playingMode = PlayMode.orderPlay
    var isShufflePlaying: Bool = false
    
    //内部播放列表相关
    var isPlayerShowing: Bool = true
    
    //睡眠定时相关
    var timeOut: Int = 10
    var timer: Timer!
    var isTimeListShowing = false
    
    //音量调节相关
    var volumeSlider: UISlider!
    var maxVolumes: Float = 10.0
    var SysctemvolumeSlider: UISlider!
    
    //改变播放逻辑
    lazy var PlaySongs:[Song] = []
    lazy var tableViewMain:UITableView = {
        var tableView:UITableView = UITableView()
        return tableView
    }()
    
    //后台播放
    let artwork1 = UIImageView()
    let mpic = MPNowPlayingInfoCenter.default()
    let mpRemote = MPRemoteCommandCenter.shared()
    var totalBackTime:Double = 0.0
    var nowBackTime:Double = 0.0
    
    //跳动按钮
     var rhythmViewDelegate:RhythmViewDelegate?
    override func loadView() {
        super.loadView()
         print(#function,"life")
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

         print(#function,"life")
    }

    override func viewDidLoad() {
        
         print(#function,"life")
       
        super.viewDidLoad()
        self.navigationController?.hidesBottomBarWhenPushed = true
        updatePlayingState()
        setMPRemoteCommandCenterEvent()
        self.navigationController?.navigationBar.isTranslucent = false
        self.view.backgroundColor = UIColor.white
       
        //退到后台
        NotificationCenter.default.addObserver(self, selector: #selector(removePlayerOnPlayerLayer), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        //回到前台
        NotificationCenter.default.addObserver(self, selector: #selector(resetPlayerToPlayerLayer), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        
        // 跳转逻辑
        if self.navigationController?.viewControllers.count == 3 {
            self.navigationController?.viewControllers.remove(at: (self.navigationController?.viewControllers.count)!-2)
        }
        hud.textLabel.text = "Loading"
        hud.show(in: self.view)
       
        videoIds.removeFirst()
        print("第一次打开播放器列表",videoIds)
        
        self.clint.getVideoWithIdentifier(self.videoId) {
            (video, error) in
            if let video = video {
                self.videoUrl = video.streamURLs[XCDYouTubeVideoQuality.HD720.rawValue]
                print(self.videoUrl,"URl")
            } else {
                print(error?.localizedDescription as Any)
            }
            self.autoPlayToNextByVC()
        }
        SharePlayerViewController.setPlayer(player: self)
        //UIinit()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
         print(#function,"life")
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    
    //观察视频播放
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let playerItem = object as? AVPlayerItem else { return }
        if keyPath == "loadedTimeRanges" {
            // 通过监听AVPlayerItem的"loadedTimeRanges"，可以实时知道当前视频的进度缓冲
            // let loadedTime = avalableDurationWithplayerItem()
            // let totalTime = CMTimeGetSeconds(playerItem.duration)
            // let percent = loadedTime/totalTime // 计算出比例
            //改变进度条
            // self.progressView.progress = Float(percent)
        } else if keyPath == "status" {
            // 监听状态改变
            if playerItem.status == AVPlayerItemStatus.readyToPlay{
                self.hud.dismiss()
                // 只有在这个状态下才能播放
                self.avplayer.play()
                print("开始播放！！！！！")
               updataLockScreenStaticInfo(playbackState: 1)
            } else {
                print("加载异常")
            }
        }
    }
    
    
    override func remoteControlReceived(with event: UIEvent?) {
        doInBackControl(with: event)
    }
    
    //缓冲进度相关
    var progressView:UIProgressView!
    func avalableDurationWithplayerItem()->TimeInterval {
        guard let loadedTimeRanges = avplayer.currentItem?.loadedTimeRanges,
            let first = loadedTimeRanges.first
            else {fatalError()}
        let timeRange = first.timeRangeValue
        let startSeconds = CMTimeGetSeconds(timeRange.start)
        let durationSecound = CMTimeGetSeconds(timeRange.duration)
        let result = startSeconds + durationSecound
        return result
    }
    
    
    func datainit()
    {
        //根据当前数据设标题
        originalVideoIds=videoIds
        print(playingIndex+videoIds.count)
        self.title = "\((playingIndex)+1)"+"/"+"\(videoIds.count)"
        //初始化AV播放器
        playerItem = AVPlayerItem(url: videoUrl!)
        // 创建视频资源
        SharePlayer.setItem(item: playerItem)
        self.avplayer =  SharePlayer.getAVplayer()
        // 监听缓冲进度改变
        playerItem.addObserver(self, forKeyPath: "loadedTimeRanges", options: NSKeyValueObservingOptions.new, context: nil)
        // 监听状态改变
        playerItem.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)
        //监听播发完的系统通知
        NotificationCenter.default.addObserver(self, selector: #selector(ModePlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object:nil )
        // 将视频资源赋值给视频播放对象
        // 初始化视频显示layer
        playerLayer =  SharePlayer.getLayer()
        // 设置显示模式
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        playerLayer.contentsScale = UIScreen.main.scale
        avplayer.actionAtItemEnd = .pause
        // 赋值给自定义的View
        // playerView=videoForLayer()
        self.playUIview.playerLayer = self.playerLayer
        // 位置放在最底下
        self.playUIview.layer.insertSublayer(playerLayer, at: 0)
        //音量控制
        self.avplayer.volume = 1
        //进度条初始化
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.value = 0
        // 从最大值滑向最小值时杆的颜色
        slider.maximumTrackTintColor = UIColor.clear
        // 从最小值滑向最大值时杆的颜色
        slider.minimumTrackTintColor = UIColor.white
        // 在滑块圆按钮添加图片
        //slider.setThumbImage(#imageLiteral(resourceName: "Handle"), for: UIControlState.normal)
        //播放过程中动态改变进度条值和时间标签
        
    }
    
    func formatPlayTime(secounds:TimeInterval)->String {
        if secounds.isNaN {
            return "00:00"
        }
        let Min = Int(secounds / 60)
        let Sec = Int(secounds.truncatingRemainder(dividingBy: 60.0))
        //print(secounds)
        return String(format: "%02d:%02d", Min, Sec)
    }
    
   
    
    deinit{
        if (playerItem != nil){
            playerItem.removeObserver(self, forKeyPath: "loadedTimeRanges")
            playerItem.removeObserver(self, forKeyPath: "status")
        }
    }
}

// MARK: - UI
private extension PlayerController {
    
    func UIinit() {
        //右上按钮
        let rightBarItem = UIBarButtonItem( image: #imageLiteral(resourceName: "List"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(listAllSongs))
        self.navigationItem.rightBarButtonItem = rightBarItem
        
         self.view.addSubview(playUIview)
        playUIview.snp.makeConstraints { (make) in
          make.top.equalTo(self.view).offset(0)
          make.height.equalTo(self.view.frame.height/2)
          make.width.equalTo(self.view.frame.width)
        }
        
        playButton.setImage(#imageLiteral(resourceName: "Play"), for: .normal)
        playButton.addTarget(self, action: #selector(play), for: UIControlEvents.touchUpInside)
        self.view.addSubview(playButton)
        playButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.playUIview).offset(190)
            make.left.equalTo(self.view).offset(self.view.frame.width/2-20)
        }
        
        prevButton.setImage(#imageLiteral(resourceName: "Backward"), for: UIControlState.normal)
        prevButton.addTarget(self, action: #selector(prev), for: UIControlEvents.touchUpInside)
        self.view.addSubview(prevButton)
        prevButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.playUIview).offset(190)
            make.left.equalTo(self.view).offset(self.view.frame.width/6)
        }
        
        nextButton.setImage(#imageLiteral(resourceName: "Forward"), for: UIControlState.normal)
        nextButton.addTarget(self, action: #selector(nexto), for: UIControlEvents.touchUpInside)
        self.view.addSubview(nextButton)
        nextButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.playUIview).offset(190)
            make.right.equalTo(self.view).offset(-self.view.frame.width/6)
        }
        
        //进度条
        // 按下的时候
        slider.addTarget(self, action: #selector(sliderTouchUpOut), for: UIControlEvents.touchDown)
        // 弹起的时候
        slider.addTarget(self, action: #selector(sliderTouchUpOut), for: UIControlEvents.touchUpOutside)
        slider.addTarget(self, action: #selector(sliderTouchUpOut), for: UIControlEvents.touchUpInside)
        slider.addTarget(self, action: #selector(sliderTouchUpOut), for: UIControlEvents.touchCancel)
        //slider.addTarget(self, action: #selector(sliderLoad), for: UIControlEvents.valueChanged)
        slider.setThumbImage(#imageLiteral(resourceName: "Handle"), for: .normal)
        slider.minimumTrackTintColor = UIColor.red
        //slider.thumbTintColor = UIColor.gray
        self.view.addSubview(slider)
        slider.snp.makeConstraints { (make) in
            make.right.left.equalToSuperview().inset(82)
            make.left.equalTo(100)
            make.bottom.equalTo(self.playUIview).offset(100)
        }
        
        //显示时间
        timeLabel.textColor = UIColor.gray
        timeLabel.font = UIFont.systemFont(ofSize: 22)
        self.view.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(slider).offset(-5)
            make.left.equalTo(slider).offset(-70)
            make.width.equalTo(100)
        }
        
        timetotalLabel.textColor = UIColor.gray
        timetotalLabel.font = UIFont.systemFont(ofSize: 22)
        self.view.addSubview(timetotalLabel)
        timetotalLabel.snp.makeConstraints { (make) in
            make.top.equalTo(slider).offset(-5)
            make.right.equalTo(slider).offset(110)
            make.width.equalTo(100)
        }
        
        //缓冲进度相关
        progressView = UIProgressView()
        progressView.backgroundColor = UIColor.lightGray
        progressView.tintColor = UIColor.red
        progressView.progress = 0
        self.view.insertSubview(progressView, belowSubview: slider)
        progressView.snp.makeConstraints { (make) in
            make.left.right.equalTo(slider)
            make.centerY.equalTo(slider)
            make.height.equalTo(2)
        }
        
        //播放模式按钮
        playingModeButton.addTarget(self, action: #selector(changeMode), for: UIControlEvents.touchUpInside)
        playingModeButton.setImage(#imageLiteral(resourceName: "RepeatNone"), for: .normal)
        self.view.addSubview(playingModeButton)
        playingModeButton.snp.makeConstraints { (make) in
            make.top.equalTo(playButton).offset(100)
            make.left.equalTo(slider).offset(-5)
        }
        
        //随机播放按钮
        shuffleModeButton.addTarget(self, action: #selector(randomMode), for: UIControlEvents.touchUpInside)
        shuffleModeButton.setImage(#imageLiteral(resourceName: "ShuffleDisabled"), for: .normal)
        self.view.addSubview(shuffleModeButton)
        shuffleModeButton.snp.makeConstraints { (make) in
            make.top.equalTo(playButton).offset(100)
            make.right.equalTo(slider).offset(5)
        }
        
        //标题栏
        musicTitleLable.font = UIFont.systemFont(ofSize: 18)
        musicTitleLable.labelSpacing = 30
        musicTitleLable.pauseInterval = 1
        musicTitleLable.scrollSpeed = 30
        musicTitleLable.textAlignment = NSTextAlignment.center
        musicTitleLable.fadeLength = 12
        musicTitleLable.scrollDirection = EFAutoScrollDirection.Left
        musicTitleLable.observeApplicationNotifications()
        self.view.addSubview(musicTitleLable)
        musicTitleLable.snp.makeConstraints { (make) in
            make.top.equalTo(slider).offset(36)
            make.width.equalTo(self.view.frame.width)
        }
        
        
        //倒计时按钮
        sleepTimerButton.setImage(#imageLiteral(resourceName: "ClockDisabled"), for: UIControlState.normal)
        sleepTimerButton.addTarget(self, action: #selector(startClicked), for: .touchUpInside)
        self.view.addSubview(sleepTimerButton)
        self.sleepTimerButton.snp.makeConstraints { (make) in
            make.top.equalTo(playButton).offset(100)
            make.left.equalTo(self.view).offset(self.view.frame.width/2-50)
            make.width.equalTo(100)
            make.height.equalTo(50)
        }
        
        //音量滑动条
        //进度条
        //frame: self.view.frame
        let systemVolumView = MPVolumeView()
        systemVolumView.showsVolumeSlider = true
        //self.view.addSubview(systemVolumView)
        for subView in systemVolumView.subviews
        {
            
            if type(of: subView).description() == "MPVolumeSlider" {
                volumeSlider = subView as! UISlider
                volumeSlider.sendActions(for: .touchUpInside)
            }
        }
        //volumeSlider = UISlider()
        // 按下的时候
        volumeSlider?.addTarget(self, action: #selector(volumeSliderTouchDown), for: UIControlEvents.touchDown)
        // 弹起的时候
        volumeSlider?.addTarget(self, action: #selector(volumeSliderTouchDown), for: UIControlEvents.touchUpOutside)
        volumeSlider?.addTarget(self, action: #selector(volumeSliderTouchDown), for: UIControlEvents.touchUpInside)
        volumeSlider?.addTarget(self, action: #selector(volumeSliderTouchDown), for: UIControlEvents.touchCancel)
        self.view.addSubview(volumeSlider)
        volumeSlider.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(82)
            make.left.equalTo(100)
            make.bottom.equalTo(self.playButton).offset(50)
        }
        
        self.view.addSubview(maxVolume)
        maxVolume.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.volumeSlider)
           
             make.right.equalTo(self.volumeSlider).offset(32)
        }
        
        self.view.addSubview(minVolume)
        minVolume.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.volumeSlider)
             make.left.equalTo(self.volumeSlider).offset(-32)
           
        }
        
        //tableView
        tableViewMain.delegate = self
        tableViewMain.dataSource = self
        //注册cell重用
        tableViewMain.register(PlayerListCell.self , forCellReuseIdentifier: "ID6")
        self.view.addSubview(tableViewMain)
        tableViewMain.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(0)
            make.height.equalTo(self.view.frame.height/2)
            make.width.equalTo(self.view.frame.width)
        }
        tableViewMain.isHidden = true
        
        //计算工具相关 CADisplayLink 的执行次数相当于屏幕的帧数
        self.link = CADisplayLink(target: self, selector: #selector(update))
        self.link.add(to: RunLoop.main, forMode: RunLoopMode.defaultRunLoopMode)
        self.navigationController?.navigationBar.isTranslucent = false
    }
}

// MARK: - 重新创建一个播放器打开逻辑
extension PlayerController {
    
    func openNewVideo(withVideoId:String,videoIndex:Int,videoList:[Item],videoTitle:String) {
        self.avplayer.pause()
        self.hud.show(in: self.view)
        PlaySongs = Util.RootClassToSongs(modle: videoList)
        print(PlaySongs,"44444",withVideoId)
        self.clint.getVideoWithIdentifier(withVideoId) {(video, error) in
            if let video = video {
                self.changeUrl = video.streamURLs[XCDYouTubeVideoQuality.HD720.rawValue]
                self.videoUrl = self.changeUrl
            } else {
                print(error?.localizedDescription as Any)
            }
            self.musicTitleLable.text = videoTitle
            self.playingIndex = videoIndex
            self.videoIds = self.PlaySongs.map{ $0.songVideoId }
            self.autoPlayToNextByItem()
            self.tableViewMain.reloadData()
            self.hud.dismiss()
        }
    }
    
    func openNewSearchVideo(withVideoId:String,videoIndex:Int,videoList:[Item],videoTitle:String) {
        self.avplayer.pause()
        self.PlaySongs = Util.RootClassToSongsBySearch(modle: videoList)
        print(PlaySongs,"44444URl")
        self.hud.show(in: self.view)
        self.clint.getVideoWithIdentifier(withVideoId) {(video, error) in
            if let video = video {
                self.changeUrl = video.streamURLs[XCDYouTubeVideoQuality.HD720.rawValue]
                self.videoUrl = self.changeUrl
            } else {
                print(error?.localizedDescription as Any)
            }
            self.musicTitleLable.text = videoTitle
            self.playingIndex = videoIndex
            self.videoIds = self.PlaySongs.map{ $0.songVideoId }
            self.autoPlayToNextByItem()
             self.tableViewMain.reloadData()
            self.hud.dismiss()
        }
    }
    
    //读取不到Url自动播放下一曲
    func autoPlayToNextByVC() {
        if self.videoUrl != nil {
            print("URL222",self.videoUrl)
            datainit()
            UIinit()
            updateUIWithIndex()
        } else {
            if playingIndex == videoIds.count {
               // self.title = "\((self.playingIndex)+1)"+"/"+"\(self.videoIds.count)"
                self.avplayer.pause()
                showNoSongUI()
            } else {
            self.playingIndex+=1
            updateUIWithIndex()
            print("第一次打开播放器列表",playingIndex)
            self.videoId=videoIds[playingIndex-1]
            print("新的ID",self.videoId)
            self.clint.getVideoWithIdentifier(self.videoId) { (video, error) in
                if let video = video {
                    self.changeUrl = video.streamURLs[XCDYouTubeVideoQuality.HD720.rawValue]
                    self.videoUrl = self.changeUrl
                } else {
                    print(error?.localizedDescription as Any)
                }
                self.autoPlayToNextByVC()
            }
        }
        }
    }
    
    func autoPlayToNextByItem() {
        
        if self.videoUrl != nil  {
            updateUIWithIndex()
            //getPlayer.setPlayer(player: self)
            self.title = "\((self.playingIndex)+1)"+"/"+"\(self.videoIds.count)"
            print("SelfUrl",self.videoUrl!)
            let changeAvplayItem: AVPlayerItem = AVPlayerItem(url: self.videoUrl!)
            SharePlayer.setItem(item: changeAvplayItem)
            self.avplayer = SharePlayer.getAVplayer()
            self.avplayer.play()
        } else {
            if playingIndex == videoIds.count-1 {
//                self.title = "\((self.playingIndex))"+"/"+"\(self.videoIds.count)"
                self.avplayer.pause()
                showNoSongUI()
            } else {
            self.playingIndex += 1
            updateUIWithIndex()
            self.videoId=videoIds[playingIndex]
            print("新的ID",self.videoId)
            self.clint.getVideoWithIdentifier(self.videoId) { (video, error) in
                if let video = video {
                    self.videoUrl = video.streamURLs[XCDYouTubeVideoQuality.HD720.rawValue]
                } else {
                    print(error?.localizedDescription as Any)
                }
                print("新的url",self.videoUrl)
                self.autoPlayToNextByItem()
            }
        }
        }
    }
    
    func openNewVideo(withVideoId:String,videoIndex:Int,videoList:Results<Song>,videoTitle:String) {
        self.avplayer.pause()
        self.PlaySongs = videoList.map{ return $0 }
        print(PlaySongs,"44444")
        self.hud.show(in: self.view)
        self.clint.getVideoWithIdentifier(withVideoId) {(video, error) in
            if let video = video {
                self.changeUrl = video.streamURLs[XCDYouTubeVideoQuality.HD720.rawValue]
                self.videoUrl = self.changeUrl
            } else {
                print(error?.localizedDescription as Any)
            }
            self.musicTitleLable.text = videoTitle
            self.playingIndex = videoIndex
            self.videoIds = self.PlaySongs.map{ $0.songVideoId }
            self.autoPlayToNextByItem()
             self.tableViewMain.reloadData()
            self.hud.dismiss()
        }
    }
    
    func openNewVideo(withVideoId:String,videoIndex:Int,videoList:[Song],videoTitle:String) {
        self.avplayer.pause()
        self.PlaySongs = videoList
        print(PlaySongs,"44444")
        self.hud.show(in: self.view)
        self.clint.getVideoWithIdentifier(withVideoId) {(video, error) in
            if let video = video {
                self.changeUrl = video.streamURLs[XCDYouTubeVideoQuality.HD720.rawValue]
                self.videoUrl = self.changeUrl
            } else {
                print(error?.localizedDescription as Any)
            }
            self.musicTitleLable.text = videoTitle
            self.playingIndex = videoIndex
            self.videoIds = self.PlaySongs.map{ $0.songVideoId }
            self.autoPlayToNextByItem()
            self.tableViewMain.reloadData()
            self.hud.dismiss()
        }
    }
    
    func updateUIWithIndex() {
        if playingIndex < PlaySongs.count{
            musicTitleLable.text = PlaySongs[playingIndex].songTitle
            self.title = "\((self.playingIndex)+1)"+"/"+"\(self.videoIds.count)"
            updataLockScreenStaticInfo(playbackState: 1)
        }
       
    }
}

// MARK: - 歌曲异常处理
extension PlayerController {
    
    func showNoSongUI() {
        
        UIinit()
        self.musicTitleLable.text = "No More Song"
        //self.playerView.backgroundColor = UIColor.black
        self.hud.dismiss()
        SharePlayerViewController.isFirstOpen = true
    }
    
    func reloadUI() {
        //self.playerView.backgroundColor = UIColor.clear
    }
    
    func updatePlayButton(button:UIButton){
        if avplayer.rate == 1 {
            button.setImage(#imageLiteral(resourceName: "Pause"), for: .normal)
        } else {
            button.setImage(#imageLiteral(resourceName: "Play"), for: .normal)
        }
    }
}

// MARK: - TableView
extension PlayerController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.avplayer.pause()
        self.playingIndex = indexPath.row
        if self.playingIndex != videoIds.count {
            self.hud.show(in: self.playUIview, animated: true)
            
            updateUIWithIndex()
            
            self.videoId = videoIds[playingIndex]
            self.clint.getVideoWithIdentifier(self.videoId) { (video, error) in
                if let video = video {
                    self.videoUrl = video.streamURLs[XCDYouTubeVideoQuality.HD720.rawValue]
                    if self.videoUrl == nil {
                        self.nexto(sender: UIButton.init())
                    } else {
                        self.playerItem = AVPlayerItem(url: self.videoUrl!)
                        self.avplayer.replaceCurrentItem(with: self.playerItem)
                        self.avplayer.play()
                        self.updataLockScreenStaticInfo(playbackState: 0)
                        self.updataLockScreenStaticInfo(playbackState: 1)
                    }
                } else {
                    print(error?.localizedDescription as Any)
                }
                self.hud.dismiss()
            }
            
            self.listAllSongs(sender: UIBarButtonItem.init())
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PlaySongs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PlayerListCell = tableView.dequeueReusableCell(withIdentifier: "ID6",for: indexPath) as! PlayerListCell
        cell.getTitle(song: PlaySongs[indexPath.row])
        return cell
    }
}

// MARK: - ButtonClickEvent
extension PlayerController {
    //移除layer
    @objc func removePlayerOnPlayerLayer() {
        if  playerLayer?.player == nil {
            return
        }
        playerLayer.player = nil
    }
    
    //重新添加layer
    @objc func resetPlayerToPlayerLayer() {
        if  playerLayer?.player == nil {
            return
        }
        playerLayer.player = avplayer
    }
    
    @objc func play(sender: UIButton) {
        //根据rate属性判断是否在播放
        if avplayer.rate == 0 {
            updataLockScreenStaticInfo(playbackState: 1)
            avplayer.play()
            playButton.setImage(#imageLiteral(resourceName: "Pause"), for: UIControlState.normal)
        } else {
            updataLockScreenStaticInfo(playbackState: 0)
            avplayer.pause()
            playButton.setImage(#imageLiteral(resourceName: "Play"),for: UIControlState.normal)
        }
    }
    
    @objc func prev(sender: UIButton) {
        self.avplayer.pause()
       
        
        if self.playingIndex != 0 && PlaySongs.count > 0 {
            self.hud.show(in: self.playUIview, animated: true)
            self.playingIndex=playingIndex-1
            
            updateUIWithIndex()
            
            self.title = "\((playingIndex)+1)"+"/"+"\(videoIds.count)"
            self.videoId=videoIds[playingIndex]
            self.clint.getVideoWithIdentifier(self.videoId) { (video, error) in
                if let video = video {
                    self.videoUrl = video.streamURLs[XCDYouTubeVideoQuality.HD720.rawValue]
                    if self.videoUrl == nil {
                        self.prev(sender: UIButton.init())
                    } else {
                    self.playerItem = AVPlayerItem(url: self.videoUrl!)
                    self.avplayer.replaceCurrentItem(with: self.playerItem)
                    self.avplayer.play()
                    self.updataLockScreenStaticInfo(playbackState: 0)
                    self.updataLockScreenStaticInfo(playbackState: 1)
                    }
                } else {
                    print(error?.localizedDescription as Any)
                }
                 self.hud.dismiss()
            }
        }
        
       
        
    }
    
    @objc func nexto(sender: UIButton) {
        
        self.avplayer.pause()
        if isShufflePlaying == true {
             self.playingIndex = Int(arc4random_uniform(UInt32(PlaySongs.count)))
        } else {
           self.playingIndex = playingIndex+1
        }
    
        if self.playingIndex < videoIds.count {
             self.hud.show(in: self.playUIview, animated: true)
            
            updateUIWithIndex()
            
            self.videoId = videoIds[playingIndex]
            self.clint.getVideoWithIdentifier(self.videoId) { (video, error) in
                if let video = video {
                    self.videoUrl = video.streamURLs[XCDYouTubeVideoQuality.HD720.rawValue]
                    if self.videoUrl == nil {
                        self.nexto(sender: UIButton.init())
                    } else {
                    self.playerItem = AVPlayerItem(url: self.videoUrl!)
                    self.avplayer.replaceCurrentItem(with: self.playerItem)
                    self.avplayer.play()
                    self.updataLockScreenStaticInfo(playbackState: 0)
                    self.updataLockScreenStaticInfo(playbackState: 1)
                    }
                } else {
                    print(error?.localizedDescription as Any)
                }
                   self.hud.dismiss()
            }
            
        }
        
      
        
    }
    
    //时间显示文本框,监听播发状态
    @objc func update() {
        // 当前播放到的时间
        let currentTime = CMTimeGetSeconds((self.avplayer.currentTime()))
        // 总时间
        guard playerItem != nil  else {return}
        let totalTime:Double = TimeInterval(playerItem.duration.value) / TimeInterval(playerItem.duration.timescale)
        // timescale 这里表示压缩比例
        let timeStr:String! = "\(formatPlayTime(secounds: currentTime))"
        let totalStr:String! = "\(formatPlayTime(secounds: totalTime))"
        if timeStr != nil
        {
            self.timeLabel.text = timeStr // 赋值
        }
        if totalStr != nil
        {
            self.timetotalLabel.text = totalStr
        }
        if !self.sliding {
            // 播放进度
            self.slider.value = Float(currentTime/totalTime)
            self.totalBackTime = totalTime
            self.nowBackTime =  totalTime*Double(self.slider.value)
            self.updataLockScreenStaticInfo(playbackState: 1)
            updatePlayButton(button: self.playButton )
            updatePlayingState()
        }
    }
    
    //音量滑动
    @objc func volumeSliderTouchDown(slider:UISlider) {
        //当视频状态为AVPlayerStatusReadyToPlay时才处理
        if self.avplayer.status == AVPlayerStatus.readyToPlay{
            avplayer.volume = maxVolumes*volumeSlider.value
        }
    }
    
    //视频进度条
    @objc func sliderTouchUpOut(slider:UISlider) {
        //当视频状态为AVPlayerStatusReadyToPlay时才处理
        if self.avplayer.status == AVPlayerStatus.readyToPlay {
            let duration = slider.value * Float(CMTimeGetSeconds((self.avplayer.currentItem!.duration)))
            let seekTime = CMTimeMake(Int64(duration), 1)
            // 指定视频位置
            self.avplayer.seek(to: seekTime, completionHandler: { (isCompleted) in
                // 别忘记改状态
                self.sliding = false
                self.updataLockScreenStaticInfo(playbackState: 1)
            })
        }
    }
    
    //播放模式的逻辑
    @objc func ModePlaying() {
        switch self.playingMode {
        case .singleCycle:
            if self.playingIndex != videoIds.count {
                self.videoId = videoIds[playingIndex]
                self.clint.getVideoWithIdentifier(self.videoId) {(video, error) in
                    if let video = video {
                        self.videoUrl = video.streamURLs[XCDYouTubeVideoQuality.HD720.rawValue]
                        self.playerItem = AVPlayerItem(url: self.videoUrl!)
                        self.avplayer.replaceCurrentItem(with: self.playerItem)
                        self.avplayer.play()
                    } else {
                        print(error?.localizedDescription as Any)
                    }
                }
                self.title = "\((playingIndex)+1)"+"/"+"\(videoIds.count)"
            }
            
        case .listCycle:
            self.playingIndex = playingIndex+1
            if self.playingIndex < videoIds.count {
                self.playingIndex -= 1
                nexto(sender: UIButton.init())
                
            } else
            {
                self.playingIndex = -1
                nexto(sender: UIButton.init())
            }
            
        case .orderPlay:
            self.playingIndex = playingIndex+1
            if self.playingIndex < videoIds.count {
                self.playingIndex -= 1
                nexto(sender: UIButton.init())

            } else
            {
                self.avplayer.pause()
            }
        }
    }
    
    //按钮改变播放模式
    @objc func changeMode(sender:UIButton)
    {
        switch self.playingMode {
        case .listCycle:
            self.playingMode = .singleCycle
            sender.setImage(#imageLiteral(resourceName: "RepeatOne"), for: .normal)
        case .orderPlay:
            self.playingMode = .listCycle
            sender.setImage(#imageLiteral(resourceName: "RepeatAll"), for: .normal)
        case .singleCycle:
            self.playingMode = .orderPlay
            sender.setImage(#imageLiteral(resourceName: "RepeatNone"), for: .normal)
        }
    }
    
    //随机播放逻辑
    @objc func randomMode(sender:UIButton)
    {
        switch isShufflePlaying {
        case true:
            isShufflePlaying = false
            
//            videoIds = originalVideoIds
            shuffleModeButton.setImage(#imageLiteral(resourceName: "ShuffleDisabled"), for: .normal)
        case false:
            isShufflePlaying=true
//            videoIds = videoIds.sorted(){(_,_)->Bool in
//                arc4random()<arc4random()
//            }
            shuffleModeButton.setImage(#imageLiteral(resourceName: "ShuffleEnabled"), for: .normal)
        }
    }
    
    //展示播放列表逻辑
    @objc func listAllSongs(sender:UIBarButtonItem){
        switch isPlayerShowing {
        case true:
            tableViewMain.reloadData()
            self.tableViewMain.isHidden = false
            self.playUIview.isHidden = true
            UIView.transition(with: tableViewMain, duration: 1, options:[.transitionFlipFromLeft] , animations: nil, completion: nil)
            isPlayerShowing = false
        case false:
            tableViewMain.reloadData()
            self.tableViewMain.isHidden = true
            self.playUIview.isHidden = false
            UIView.transition(with: playUIview, duration: 0.75, options:[.transitionFlipFromRight] , animations: nil, completion: nil)
           // UIView.transition(from: playUIview, to: tableViewMain, duration: 1, options: [.curveEaseOut, .transitionFlipFromBottom], completion: nil)
            isPlayerShowing = true
        }
    }
    
    //倒计时相关
    @objc func startClicked() {
        let alertController = UIAlertController(title: "Sleep Timer", message: "",preferredStyle: .actionSheet)
        let actionOff = UIAlertAction(title: "Off", style: .default, handler: {
            action in
            //self.timer.invalidate()
            if self.timer != nil {
                self.timer.fireDate = Date.distantFuture
                self.sleepTimerButton.setImage(#imageLiteral(resourceName: "ClockDisabled"), for: .normal)
                self.sleepTimerButton.setTitle("", for: .normal)
            }
           
        })
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        let action10 = UIAlertAction(title: "10 minutes", style: .default, handler:{
            action in
            self.timeOut = 10*60
            self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(self.tickDown), userInfo: nil, repeats: true)
        })
        let action20 = UIAlertAction(title: "20 minutes", style: .default, handler:{
            action in
            self.timeOut = 20*60
            self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(self.tickDown), userInfo: nil, repeats: true)
        })
        let action30 = UIAlertAction(title: "30 minutes", style: .default, handler: {
            action in
            self.timeOut = 30*60
            self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(self.tickDown), userInfo: nil, repeats: true)
        })
        let action60 = UIAlertAction(title: "60 minutes", style: .default, handler: {
            action in
            self.timeOut = 60*60
            self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(self.tickDown), userInfo: nil, repeats: true)
        })
        let action90 = UIAlertAction(title: "90 minutes", style: .default, handler: {
            action in
            self.timeOut = 90*60
            self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(self.tickDown), userInfo: nil, repeats: true)
        })
        alertController.addAction(cancelAction)
        alertController.addAction(actionOff)
        alertController.addAction(action10)
        alertController.addAction(action20)
        alertController.addAction(action30)
        alertController.addAction(action60)
        alertController.addAction(action90)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func tickDown() {
        //将剩余时间减少1秒
        timeOut -= 1
        print(timeOut)
        //修改UIDatePicker的剩余时间
        sleepTimerButton.setImage(#imageLiteral(resourceName: "ClockEnabled"), for: .normal)
        let Min = timeOut / 60
        let Sec = timeOut % 60
        sleepTimerButton.setTitle("\(Min):\(Sec)", for: .normal)
        //如果剩余时间小于等于0
        if timeOut <= 0 {
            //取消定时器
            timer.invalidate()
            self.sleepTimerButton.isEnabled = true
            self.avplayer.pause()
        }
    }
}

// MARK: - 后台播放
extension PlayerController {
    
    override func viewWillAppear(_ animated: Bool) {
        print(#function,"life")
         self.tabBarController?.tabBar.isHidden = true
        //告诉系统接受远程响应事件，并注册成为第一响应者
        UIApplication.shared.beginReceivingRemoteControlEvents()
        self.becomeFirstResponder()
       
    }
    
    override func viewDidDisappear(_ animated: Bool) {
         print(#function,"life")
        //停止接受远程响应事件
//        UIApplication.shared.endReceivingRemoteControlEvents()
//        self.resignFirstResponder()
    }
    
    //是否能成为第一响应对象
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
   
    
    func updataLockScreenStaticInfo (playbackState:Int) {
        if playingIndex >= PlaySongs.count || playingIndex < 0 {
            return
        }
        //专辑封面
        let mySize = CGSize(width: 400, height: 400)
        let imageurl = URL(string:  self.PlaySongs[self.playingIndex].songPhotoUrl)
        var artwork = UIImage()
        self.artwork1.sd_setImage(with: imageurl) { ( thisuiimage, error, sdimagetypr, url ) in
            artwork = thisuiimage!
            
        }
        
        let albumArt = MPMediaItemArtwork(boundsSize:mySize) { sz in
            return artwork
        }
        //            mpic.nowPlayingInfo = [MPNowPlayingInfoPropertyElapsedPlaybackTime: totalTime*Double(self.slider.value),
        //                                   MPMediaItemPropertyPlaybackDuration:totalTime]
        mpic.nowPlayingInfo = [MPMediaItemPropertyTitle:PlaySongs[playingIndex].songTitle,
                               MPMediaItemPropertyArtwork: albumArt,
                               MPNowPlayingInfoPropertyElapsedPlaybackTime: nowBackTime,
                               MPMediaItemPropertyPlaybackDuration:totalBackTime,
                               MPNowPlayingInfoPropertyPlaybackRate:playbackState]
    }
        
        //后台操作
       func doInBackControl(with event: UIEvent?) {
            guard let event = event else {
                print("no event\n")
                return
            }
            
            if event.type == UIEventType.remoteControl {
                switch event.subtype {
                case .remoteControlTogglePlayPause:
                    print("22223","暂停/播放")
                    play(sender: self.playButton)
                case .remoteControlPreviousTrack:
                    prev(sender: UIButton.init())
                case .remoteControlNextTrack:
                    nexto(sender: UIButton.init())
                case .remoteControlPlay:
                   self.avplayer.play()
                     updataLockScreenStaticInfo(playbackState: 1)
                    updatePlayingState()
                case .remoteControlPause:
                    avplayer.pause()
                    updatePlayingState()
                    print("暂停")
                    //后台播放显示信息进度停止
                   updataLockScreenStaticInfo(playbackState: 0)
                case .remoteControlBeginSeekingBackward:
                    print("333333")
                default:
                    break
                }
            }
    }
}

// MARK: - 设置播放跳动条
extension PlayerController {
   func  updatePlayingState() {
    if self.rhythmViewDelegate != nil {
        rhythmViewDelegate?.showRhythmState(id: videoIds[playingIndex], playRate: avplayer.rate)
    }
    }
    func setMPRemoteCommandCenterEvent() {
        mpRemote.changePlaybackPositionCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
//            print(Int(round(event.timestamp))/(60000*3600))
//            mpRemote.  MPChangePlaybackPositionCommandEvent.positionTime
            let mevent = event as! MPChangePlaybackPositionCommandEvent
            print(mevent.positionTime)
            self.slider.value = Float(mevent.positionTime/self.totalBackTime)
            
            //当视频状态为AVPlayerStatusReadyToPlay时才处理
            if self.avplayer.status == AVPlayerStatus.readyToPlay {
                let duration = self.slider.value * Float(CMTimeGetSeconds((self.avplayer.currentItem!.duration)))
                let seekTime = CMTimeMake(Int64(duration), 1)
                // 指定视频位置
                self.avplayer.seek(to: seekTime, completionHandler: { (isCompleted) in
                    // 别忘记改状态
                    self.sliding = false
                    self.updataLockScreenStaticInfo(playbackState: 1)
                })
            }
            return .success
        }
        mpRemote.nextTrackCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            self.nexto(sender: UIButton.init())
            
            return .success
        }
        mpRemote.previousTrackCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            self.prev(sender: UIButton.init())
            return .success
        }
        mpRemote.stopCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            return .success
        }
        mpRemote.pauseCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            self.avplayer.pause()
            self.updatePlayingState()
            print("暂停")
            //后台播放显示信息进度停止
            self.updataLockScreenStaticInfo(playbackState: 0)
            return .success
        }
        mpRemote.playCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            self.avplayer.play()
            self.updataLockScreenStaticInfo(playbackState: 1)
            self.updatePlayingState()
            return .success
        }
    }
}
