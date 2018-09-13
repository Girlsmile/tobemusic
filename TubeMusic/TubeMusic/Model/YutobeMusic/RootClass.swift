//
//	RootClass.swift
//
//	Create by 智鹏 古 on 2/8/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import HandyJSON
class RootClass:HandyJSON{
    required init() {}
    
    required init(coder aDecoder: NSCoder) {
     self.kind = aDecoder.decodeObject(forKey: "kind") as? String
    }
    
	var etag : String!
	var items : [Item]!
	var kind : String!
	var nextPageToken : String!
    var prevPageToken: String!
	var pageInfo : PageInfo!
	var regionCode : String!

}

extension RootClass: NSCoding{
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(kind,forKey: "kind")
    }
}
