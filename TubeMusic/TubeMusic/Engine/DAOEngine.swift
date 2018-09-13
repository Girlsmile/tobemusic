//
//  DAOEngine.swift
//  TubeMusic
//
//  Created by 古智鹏 on 2018/8/23.
//  Copyright © 2018年 古智鹏. All rights reserved.
//

import Foundation
import RealmSwift
class DAOEngine {
    static let shareInstance = DAOEngine()
    private init(){ }
    static let config = Realm.Configuration(fileURL: URL(string: NSHomeDirectory() + "/Library"+"/music.realm"),schemaVersion: ConfigurationVersion.schemaVersion,migrationBlock: nil)
//    暴露一个realmRealm.Configuration.init(fileURL: URL(string: NSHomeDirectory() + "/Library"+"/music.realm"),schemaVersion: ConfigurationVersion.schemaVersion, migrationBlock: nil)
    static let realm = try! Realm(configuration: config)
}

extension DAOEngine {
    
    //增
   static func add<T: Object>(_ object:T) {
        try! realm.write {
            realm.add(object)
        }
    }
    
    //删
   static  func delete<T: Object>(object:T) {
       // let realm = try! Realm()
        try! realm.write {
            realm.delete(object)
        }
    }
    
    //查
    static func query<T: Object>(_ type: T.Type, _ filterStr: String? = nil) -> Results<T> {//查
       // let realm = try! Realm()    c
        if let str = filterStr {
            return realm.objects(type).filter(str)
        }
        else {
            return realm.objects(type)
        }
    }
    
    //多线程查询
    static func query<T: Object>(_ type: T.Type, _ filterStr: String? = nil, block:@escaping ((_ results: Results<T>)->Void)) {
        DispatchQueue(label: "background").async {
           // let realm = try! Realm()
            
            if let str = filterStr {
                let objects = realm.objects(type).filter(str)
                block(objects)
            }
            else {
                let objects = realm.objects(type)
                block(objects)
            }
        }
    }
        
    //Song的增删改查
    //增加不计算重复的vidoeId
    static func addSong(song:Song,listName:String) {
          var isSame = false
          var isHavaName = false
         // let realm = try! Realm()
          let addedSongs: Results<Song> = DAOEngine.query(Song.self)
          //let nSong = song.copy() as! Song
        if addedSongs.count > 0 {
            
            for msong in addedSongs {
                if msong.songVideoId == song.songVideoId {
                    for mlistName in msong.owners {
                        if mlistName == listName {
                            isHavaName = true
                        }
                    }
                        try! realm.write {
                            if !isHavaName {
                              msong.owners.append(listName)
                              print("加listName")
                              isHavaName = false
                            }
                            isSame = true
                            print("加不到listName")
                            //realm.add(msong)
                        }
                    
                } else {
                    
                }
            }
            if !isSame {
                try! realm.write {
                    song.owners.append(listName)
                    realm.add(song)
                    print("加歌曲")
                    isSame = false
                }
            }
            
            
        } else {
            try! realm.write {
                song.owners.append(listName)
                realm.add(song)
                isSame = false
            }
        }
     }
    //根据videoID删song
    static func deleteSongs(bySong: [Song])
    {
       // let realm = try! Realm()
        for id in bySong {
            let deletedSongs:Results<Song> = DAOEngine.query(Song.self).filter("songVideoId = '\(id.songVideoId)'")
            try! realm.write {
                realm.delete(deletedSongs)
            }
        }
  }
    
    //根据videoIDs 和 歌单名字 删除歌单名字
    static func deleteSongs(bySong: [Song],mlistName:String)
    {
        // let realm = try! Realm()
        for id in bySong {
            let deletedSongs:Results<Song> = DAOEngine.query(Song.self).filter("songVideoId = '\(id.songVideoId)'")
            try! realm.write {
                var i = 0
                if (deletedSongs.first?.owners.count)! > 1 {
                    for listName in (deletedSongs.first?.owners)! {
                        if mlistName == listName {
                            deletedSongs.first?.owners.remove(at: i)
                        } else {
                            i = i+1
                        }
                    }
                } else {
                  realm.delete(deletedSongs)
                }
            }
        }
    }
    
    //给定一个listName,根据歌单名显示
    static func showSong(listName:String)->[Song] {
        var result:[Song] = []
        let aList: Results<SongList> = DAOEngine.query(SongList.self).filter("name = '\(listName)'")
        for song in (aList.first?.songs)! {
            for owner in song.owners {
                if owner == listName {
                 result.append(song)
                }
            }
        }
        return result
    }
    
    //defalt列表的显示
    //给定一个listName,根据歌单名显示
    static func showSongInDefault(listName:String)->[Song] {
        var result:[Song] = []
        let aList: Results<Song> = DAOEngine.query(Song.self)
        for song in aList {
            for owner in song.owners {
                if owner == listName {
                    result.append(song)
                }
            }
        }
        return result
    }
    
    //给定一个listName,根据歌单名显示长度
    static func showSong(listName:String)->Int{
        var count: Int = 0
        let aList: Results<SongList> = DAOEngine.query(SongList.self).filter("name = '\(listName)'")
        for song in (aList.first?.songs)! {
            for owner in song.owners {
                if owner == listName {
                  count = count+1
                }
            }
        }
        return count
    }

    //根据SongList的name 加
    static func addSongListByName( _ name:String) {
       // let realm = try! Realm()
        let aList:SongList = SongList()
        aList.name = name
        try! realm.write {
            realm.add(aList)
        }
    }
    //根据SongList的name 删除
    static func deleteSongListByName( _ name:String) {
       // let realm = try! Realm()
        let aList: Results<SongList> = DAOEngine.query(SongList.self).filter("name = '\(name)'")
        try! realm.write {
            realm.delete(aList)
        }
    }
    
    //根据一组songs添加到一组播放列表
    static func addSongsToList(songs: [Song],listNames: [String]) {
      // let realm = try! Realm()
        var isSame = false
        var  isHavaName = false
        for listName in listNames {
            
            let aList: Results<SongList> = DAOEngine.query(SongList.self).filter("name = '\(listName)'")
            if (aList.first?.songs.count)! >= 1 {
            //有歌曲
            for newSong  in songs {
                 print("一组songs相同1",listName)
                for oldSong in (aList.first?.songs)! {
                    if oldSong.songVideoId == newSong.songVideoId {
                        
                        for mlistName in oldSong.owners {
                            if mlistName == listName {
                                isHavaName = true
                            }
                        }
                        
                        try! realm.write {
                            if !isHavaName {
                                oldSong.owners.append(listName)
                                print("加listName")
                                isHavaName = false
                            }
                        }
                        isSame = true
                         print("一组songs相同2",listName)
                        break
                    } else {
                        isSame = false
                    }
                }

                if !isSame {
                     //let nSong:Song = newSong.copy() as! Song
                    try! realm.write {
                           print("一组songs相同3",listName)
//                        nSong.songDuration = newSong.songDuration
//                        nSong.songVideoId = newSong.songVideoId
//                        nSong.songTitle = newSong.songTitle
//                        nSong.songPhotoUrl = newSong.songPhotoUrl
                        newSong.owners.append(listName)
                        aList.first?.songs.append(newSong)
                    }
                } else {
                    isSame = false
                }
             }
            } else {
            //没有歌曲
                for newSong in songs {
                    try! realm.write {
                        print("一组没有歌")
                          //let nSong:Song = newSong.copy() as! Song
//                        let nSong:Song = Song()
//                        nSong.songDuration = newSong.songDuration
//                        nSong.songVideoId = newSong.songVideoId
//                        nSong.songTitle = newSong.songTitle
//                        nSong.songPhotoUrl = newSong.songPhotoUrl
                        newSong.owners.append(listName)
                        aList.first?.songs.append(newSong)
                          print("一组songs",listName)
                    }
                }
            }
            
        }
    }
    
    //根据歌单名和歌曲集合删除音乐
    
}

