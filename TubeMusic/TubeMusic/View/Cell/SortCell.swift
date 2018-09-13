//
//  sortCell.swift
//  TubeMusic
//
//  Created by 古智鹏 on 2018/8/6.
//  Copyright © 2018年 古智鹏. All rights reserved.
//

import Foundation
import UIKit
class SortCell: UITableViewCell {
    //title
  public lazy var labelTitle:UILabel = UILabel(frame: CGRect(x: 20, y: 0, width: 150, height:50))
    public lazy var lableButton:UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 500, height: 50))
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
       initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initUI(){
//        labelTitle.snp.makeConstraints { (make) in
//            make.top.equalTo(contentView).offset(10)
//            make.left.equalTo(10)
//        }
        
        labelTitle.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action:#selector(onclick))
        labelTitle.addGestureRecognizer(tapGesture)
        
         self.addSubview(labelTitle)
        self.addSubview(lableButton)
    }
    
    internal func title(sort:SortUrl)
    {
        labelTitle.text=sort.rawValue
    }
    
    @objc func onclick(sender:UILabel){
        sender.backgroundColor=UIColor.red
        print("6666")
    }
    
}
