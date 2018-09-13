//
//  getPlayer.swift
//  TubeMusic
//
//  Created by 古智鹏 on 2018/8/14.
//  Copyright © 2018年 古智鹏. All rights reserved.
//

import Foundation
class SharePlayerViewController{
    static var isFirstOpen = true
    static var player:PlayerController?
    static func getPlayerController()->PlayerController{
            if self.player != nil {
            return player!
        }
        else {
            player=PlayerController()
            return player!
        }
    }
    static func setPlayer(player:PlayerController){
           self.player=player
    }
}
