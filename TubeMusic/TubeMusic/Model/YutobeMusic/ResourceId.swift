//
//  resourceId.swift
//  TubeMusic
//
//  Created by 古智鹏 on 2018/8/6.
//  Copyright © 2018年 古智鹏. All rights reserved.
//

import Foundation
import HandyJSON
class ResourceId:HandyJSON{
    var kind : String!
    var playlistId : String!
    var channelId : String!
    var videoId : String!
    required init() {
    }
}
