//
//  Util.swift
//  TubeMusic
//
//  Created by 古智鹏 on 2018/8/29.
//  Copyright © 2018年 古智鹏. All rights reserved.
//

import Foundation
class Util {
    static func RootClassToSongs(modle: [Item]) -> [Song] {
        var songs: [Song] = []
        for currentItem in modle {
            let currentSong = Song()
            currentSong.songPhotoUrl = currentItem.snippet.thumbnails.defaultField.url
            currentSong.songTitle = currentItem.snippet.title
            currentSong.songVideoId = currentItem.snippet.resourceId.videoId
            currentSong.songDuration = "5:34"
            currentSong.isSelected = currentItem.isselsected
            songs.append(currentSong)
        }
        return songs
    }
    
    static func RootClassToSongsBySearch(modle: [Item]) -> [Song] {
        var songs: [Song] = []
        for currentItem in modle {
            let currentSong = Song()
            currentSong.songPhotoUrl = currentItem.snippet.thumbnails.defaultField.url
            currentSong.songTitle = currentItem.snippet.title
            currentSong.songVideoId = currentItem.id.videoId
            currentSong.songDuration = "5:34"
            currentSong.isSelected = currentItem.isselsected
            songs.append(currentSong)
        }
        return songs
    }
}
