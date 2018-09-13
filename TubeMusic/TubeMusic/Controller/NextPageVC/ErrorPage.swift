//
//  errorNoPage.swift
//  TubeMusic
//
//  Created by 古智鹏 on 2018/8/8.
//  Copyright © 2018年 古智鹏. All rights reserved.
//

import Foundation
import SnapKit
class ErrorPage: UIViewController {
    let lable:UILabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lable.text="404,页面不见了。。。"
        self.view.addSubview(self.lable)
        lable.snp.makeConstraints({
            make in
            make.width.equalTo(200)
            make.height.equalTo(200)
        })
    }    
}
