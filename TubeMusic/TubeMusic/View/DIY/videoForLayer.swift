//
//  videoForLayer.swift
//  TubeMusic
//
//  Created by 古智鹏 on 2018/8/9.
//  Copyright © 2018年 古智鹏. All rights reserved.
//

import Foundation
import UIKit
import AVKit
class videoForLayer:UIView {
    
    var playerLayer:AVPlayerLayer?
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame=self.frame
    }
    
    
}
