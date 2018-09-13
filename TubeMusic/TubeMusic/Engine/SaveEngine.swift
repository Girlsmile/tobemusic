//
//  StorelnPlist.swift
//  TubeMusic
//
//  Created by 古智鹏 on 2018/8/3.
//  Copyright © 2018年 古智鹏. All rights reserved.
//

import Foundation
class SaveEngine {
    //存储路径utbemusic.plist
    static let savePath = "\(NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, .userDomainMask, true).first!)/"
   
    //将字典数据存到指定位置
    static func saveDic(data:NSDictionary,name:String)->Bool{
        let url = savePath+name
        return data.write(toFile: url, atomically: true)
    }
    
    //将字典读出来
    static func readDic(name:String)->NSDictionary?{
        let url = savePath+name
        return NSDictionary(contentsOfFile: url)
    }
}
