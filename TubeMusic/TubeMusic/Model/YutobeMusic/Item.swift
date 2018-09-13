//
//	Item.swift
//
//	Create by 智鹏 古 on 2/8/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import HandyJSON
class Item:HandyJSON{
    required init() {
    }
    

	var etag : String!
	var id : Id!
	var kind : String!
	var snippet : Snippet!
    //是否显示相关
    var isselsected = false

	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: NSDictionary){
		etag = dictionary["etag"] as? String
		if let idData = dictionary["id"] as? NSDictionary{
			id = Id(fromDictionary: idData)
		}
		kind = dictionary["kind"] as? String
		if let snippetData = dictionary["snippet"] as? NSDictionary{
			snippet = Snippet(fromDictionary: snippetData)
		}
	}

}
