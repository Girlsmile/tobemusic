//
//  playingList.swift
//  TubeMusic
//
//  Created by 古智鹏 on 2018/8/10.
//  Copyright © 2018年 古智鹏. All rights reserved.
//

import Foundation
import AVKit
class  SharePlayer:AVQueuePlayer {
    
//我实在是没办法写成计算属性，只能暴露两个get set 方法了
//    private static var getPlayingList = playingList()
//    private static var getPlayingLooper = AVPlayerLooper(player: getList(), templateItem: getList().items()[0])
    private static var item:AVPlayerItem!
    private static var avLayer:AVPlayer!
    private static var avPlayLayer:AVPlayerLayer!
    static var netMusicIsPlaying:Bool!
    static var isPlayOffline:Bool!
    
    private override init() {
        super.init()
    }
    
//    static func getList() -> playingList{
//        return getPlayingList
//    }
    
    static func getLayer() -> AVPlayerLayer{
        if self.avPlayLayer == nil{
         self.avPlayLayer = AVPlayerLayer(player: self.avLayer)
            //后台播放
            var bgTask:UIBackgroundTaskIdentifier = 0
            if UIApplication.shared.applicationState == UIApplicationState.background {
                self.avLayer.play()
                netMusicIsPlaying = true
                let app:UIApplication = UIApplication.shared
                let newTask:UIBackgroundTaskIdentifier = app.beginBackgroundTask(expirationHandler: nil)
                if newTask != UIBackgroundTaskInvalid {
                    app.endBackgroundTask(bgTask)
                }
                bgTask = newTask
            }else{
                 self.avLayer.play()
                netMusicIsPlaying = true
                isPlayOffline = false
            }
        }
         return avPlayLayer
    }
    
    static func getAVplayer() -> AVPlayer{
        if self.avLayer == nil  {
            self.avLayer=AVPlayer(playerItem: item)
        }
        else
        {
            self.avLayer.replaceCurrentItem(with: item)
        }
        return avLayer
    }
    
    static func setItem(item:AVPlayerItem){
       self.item=item
    }
}
