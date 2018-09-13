//
//  SongList.swift
//  TubeMusic
//
//  Created by 古智鹏 on 2018/8/23.
//  Copyright © 2018年 古智鹏. All rights reserved.
//

import Foundation
import RealmSwift
class SongList: Object {
    var songs = List<Song>()
    @objc dynamic var name: String = ""
//    override static func primaryKey() -> String? {
//        return "name"
//    }
}

extension SongList: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        let copyObject = SongList()
        copyObject.songs = songs
        copyObject.name = name
        return copyObject
    }
}
