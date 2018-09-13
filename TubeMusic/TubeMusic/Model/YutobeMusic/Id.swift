//
//	Id.swift
//
//	Create by 智鹏 古 on 2/8/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import HandyJSON
class Id:HandyJSON{
    var kind : String!
	var playlistId : String!
    var channelId : String!
    var videoId : String!

    required init() {
    }
	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
    init(fromDictionary dictionary: NSDictionary){
		//kind = dictionary["kind"] as? String
		playlistId = dictionary["playlistId"] as? String
	}

}
