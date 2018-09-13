//
//  Her+CoreDataProperties.swift
//  
//
//  Created by 古智鹏 on 2018/8/20.
//
//

import Foundation
import CoreData


extension Her {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Her> {
        return NSFetchRequest<Her>(entityName: "Her")
    }

    @NSManaged public var height: Double
    @NSManaged public var id: Int32
    @NSManaged public var name: String?

}
