//
//  timerCell.swift
//  TubeMusic
//
//  Created by 古智鹏 on 2018/8/15.
//  Copyright © 2018年 古智鹏. All rights reserved.
//

import Foundation
import UIKit
class TimerCell: UITableViewCell {
    //title
    public lazy var labelTitle:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height:50))
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(labelTitle)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
      internal func title(num:Int)
    {
        labelTitle.text="\(num)"
    }
}
