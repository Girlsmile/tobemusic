//
//  Person.swift
//  TubeMusic
//
//  Created by 古智鹏 on 2018/8/21.
//  Copyright © 2018年 古智鹏. All rights reserved.
//

import Foundation
import RealmSwift
class Person: Object {
    @objc dynamic var name = ""
    @objc dynamic var picture: Data? = nil
    let dogs:[Dog]? = nil
}
