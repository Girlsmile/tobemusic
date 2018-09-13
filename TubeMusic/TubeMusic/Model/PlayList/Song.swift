//
//  Song.swift
//  TubeMusic
//
//  Created by 古智鹏 on 2018/8/21.
//  Copyright © 2018年 古智鹏. All rights reserved.
//

import Foundation
import RealmSwift
class Song: Object {
     //必须使用required关键字修饰
     @objc dynamic var songPhotoUrl = ""
     @objc dynamic var songTitle = ""
     @objc dynamic var songVideoId = ""
     @objc dynamic var songDuration = ""
     @objc dynamic var isSelected = false
     var owners = List<String>()
    
    
    
//    override static func primaryKey() -> String? {
//        return "songVideoId"
//    }
}

extension Song: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        print("6666666")
        let copyObject = Song()
        copyObject.songVideoId = songVideoId
        copyObject.songTitle = songTitle
        copyObject.songPhotoUrl = songPhotoUrl
        copyObject.songDuration = songDuration
        return copyObject
    }
}
