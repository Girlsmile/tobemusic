//
//  Father.swift
//  TubeMusic
//
//  Created by 古智鹏 on 2018/8/21.
//  Copyright © 2018年 古智鹏. All rights reserved.
//

import Foundation
class Father: NSObject {
    var name: String!
    var son :String!
    
    required  init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.son = aDecoder.decodeObject(forKey: "son") as! String
    }
    
    override init() {
        super.init()
    }
    
   
}

extension Father :NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name,forKey: "name")
        aCoder.encode(son,forKey: "son")
    }
}
