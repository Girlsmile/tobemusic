//
//  ConstomSlide.swift
//  TubeMusic
//
//  Created by 古智鹏 on 2018/9/10.
//  Copyright © 2018年 古智鹏. All rights reserved.
//

import Foundation
import UIKit
class ConstomSlide: UIView {
    private let textLabel = UILabel()
    
    
    private let bar = UIView()
    
    public var progress: Float = 0 {
        didSet{
            percent = Int(progress * 100)
        }
    }
    
    var percent: Int = 0 {
        didSet {
            if percent > 100 {
                percent = 100
            }else if percent < 0 {
                percent = 0
            }
            textLabel.text =  "\(percent)%"
            setNeedsLayout()
        }
    }
    
    //文本颜色
    var color: UIColor = UIColor.black {
        didSet {
            textLabel.textColor = color
        }
    }
    
    //进度条颜色
    var barColor: UIColor = UIColor.orange {
        didSet {
            bar.backgroundColor = barColor
        }
    }
    
    //进度条背景颜色
    var barBgColor: UIColor = UIColor.white {
        didSet {
            layer.backgroundColor = barBgColor.cgColor
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialSetup()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initialSetup()
    }
    
    private func initialSetup(){
        bar.backgroundColor = self.barColor
        addSubview(bar)
        
        self.layer.cornerRadius = CGFloat(12)
        self.layer.masksToBounds = true
        self.bar.layer.cornerRadius = CGFloat(12)
        self.bar.layer.masksToBounds = true
        
        textLabel.textAlignment = .center
        textLabel.numberOfLines = 0
        textLabel.textColor = self.color
        textLabel.text = "\(self.percent)%"
        addSubview(textLabel)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.backgroundColor = self.barBgColor.cgColor
        
        var barFrame = bounds
        barFrame.size.width *= (CGFloat(self.percent) / 100)
        bar.frame = barFrame
        
        textLabel.frame = bounds
    }
}
